vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = { hint = { enable = true } },
	},
})

-- TypeScript 7+ має вбудований LSP (`tsc --lsp --stdio`),
-- окремий typescript-language-server більше не потрібен. npx завантажує
-- TypeScript у власний кеш, коли відкривається JS/TS-проєкт.
local tsc_cmd = { "tsc", "--lsp", "--stdio" }
if vim.fn.has("win32") == 1 then
	-- npm exposes npx as a .cmd shim on Windows; spawn it through cmd.exe.
	if vim.fn.executable("npx") == 1 then
		tsc_cmd = {
			vim.env.ComSpec or "cmd.exe",
			"/d",
			"/c",
			"npx.cmd",
			"--yes",
			"--package",
			"typescript@7",
			"tsc",
			"--lsp",
			"--stdio",
		}
	else
		tsc_cmd = { vim.env.ComSpec or "cmd.exe", "/d", "/c", "tsc.cmd", "--lsp", "--stdio" }
	end
	-- On Unix, prefer the npm package runner and keep a global tsc fallback.
elseif vim.fn.executable("npx") == 1 then
	tsc_cmd = { "npx", "--yes", "--package", "typescript@7", "tsc", "--lsp", "--stdio" }
end

vim.lsp.config("tsc", {
	cmd = tsc_cmd,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	settings = {
		inlayHints = {
			parameterNames = { enabled = "all" },
			parameterTypes = { enabled = true },
			variableTypes = { enabled = true },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = true },
			enumMemberValues = { enabled = true },
		},
	},
})

local basedpyright_cmd = { "basedpyright-langserver", "--stdio" }
if vim.fn.executable("uvx") == 1 then
	basedpyright_cmd = { "uvx", "--from", "basedpyright", "basedpyright-langserver", "--stdio" }
end

vim.lsp.config("basedpyright", {
	-- uvx installs/caches BasedPyright on first use without Mason or a global pip.
	cmd = basedpyright_cmd,
	filetypes = { "python" },
	root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", ".git" },
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				inlayHints = {
					variableTypes = true,
					callArgumentNames = true,
					functionReturnTypes = true,
					genericTypes = true,
				},
			},
		},
	},
})

-- лінт/форматування; типи лишаються за basedpyright, тут вимикаємо hover,
-- щоб не конкурував з basedpyright-ним hover
local ruff_cmd = { "ruff", "server" }
if vim.fn.executable("ruff") ~= 1 and vim.fn.executable("uvx") == 1 then
	ruff_cmd = { "uvx", "ruff", "server" }
end

vim.lsp.config("ruff", {
	-- Prefer an existing native binary; uvx is a zero-global-install fallback.
	cmd = ruff_cmd,
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

-- Build the latest checked-out cr-analyzer source with scripts/install-cr-analyzer.sh.
-- CR_ANALYZER_BIN can point at a custom build instead.
local cr_analyzer = vim.env.CR_ANALYZER_BIN
	or vim.fs.joinpath(
		vim.fn.stdpath("data"),
		"cr-analyzer",
		vim.fn.has("win32") == 1 and "cr-analyzer.exe" or "cr-analyzer"
	)
cr_analyzer = vim.fn.expand(cr_analyzer)
vim.lsp.config("cr_analyzer", {
	cmd = { cr_analyzer },
	filetypes = { "crystal" },
	root_markers = { "shard.yml", "shard.lock", ".git" },
})

vim.lsp.enable({ "lua_ls", "tsc", "basedpyright", "ruff", "cr_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local map = vim.keymap.set
		local opts = { buffer = args.buf }
		map("n", "<leader>gd", vim.lsp.buf.definition, opts)
		map("n", "<leader>gD", vim.lsp.buf.declaration, opts)
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		map("n", "<leader>ce", function()
			vim.diagnostic.open_float(nil, { focus = false })
		end, opts)

		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- basedpyright уже дає hover; ruff лишаємо тільки за лінт/форматування
		if client and client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end

		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
			map("n", "<leader>ch", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
			end, opts)
		end
	end,
})

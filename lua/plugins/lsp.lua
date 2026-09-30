vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = { hint = { enable = true } },
	},
})

-- TypeScript 7+ має вбудований LSP (`tsc --lsp --stdio`),
-- окремий typescript-language-server більше не потрібен
vim.lsp.config("tsc", {
	cmd = { "tsc", "--lsp", "--stdio" },
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

vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
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
vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

vim.lsp.enable({ "lua_ls", "tsc", "basedpyright", "ruff" })

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

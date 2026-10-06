-- на Windows tree-sitter-cli за замовчуванням шукає MSVC (cl.exe) і саме
-- передає zig-у 4-компонентний Rust-style triple (x86_64-pc-windows-msvc),
-- який zig не розуміє ("UnknownOperatingSystem"). Обгортка bin/zig-cc.cmd
-- переписує triple у формат, який zig приймає, і викликає "zig cc".
if vim.fn.has("win32") == 1 and vim.fn.executable("zig") == 1 then
	vim.env.CC = vim.fs.joinpath(vim.fn.stdpath("config"), "bin", "zig-cc.cmd")
end

require("nvim-treesitter").setup()
require("config.treesitter_crystal")

local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"python",
	"javascript",
	"typescript",
	"tsx",
	"markdown",
	"markdown_inline",
	"crystal",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "vim", "help", "python", "javascript", "typescript", "typescriptreact", "markdown", "crystal" },
	callback = function()
		local ok = pcall(vim.treesitter.start)
		if not ok then
			return
		end

		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang and vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

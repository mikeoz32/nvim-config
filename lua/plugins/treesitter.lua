-- на Windows tree-sitter-cli за замовчуванням шукає MSVC (cl.exe) і саме
-- передає zig-у 4-компонентний Rust-style triple (x86_64-pc-windows-msvc),
-- який zig не розуміє ("UnknownOperatingSystem"). Обгортка bin/zig-cc.cmd
-- переписує triple у формат, який zig приймає, і викликає "zig cc".
if vim.fn.has("win32") == 1 and vim.fn.executable("zig") == 1 then
	vim.env.CC = vim.fn.stdpath("config") .. "/bin/zig-cc.cmd"
end

require("nvim-treesitter").setup()

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
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "vim", "help", "python", "javascript", "typescript", "typescriptreact", "markdown" },
	callback = function()
		vim.treesitter.start()

		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang and vim.treesitter.query.get(lang, "indents") then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

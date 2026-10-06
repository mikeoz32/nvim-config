local function register_parser()
	require("nvim-treesitter.parsers").crystal = {
		install_info = {
			url = "https://github.com/crystal-lang-tools/tree-sitter-crystal",
			revision = "50ca9e6fcfb16a2cbcad59203cfd8ad650e25c49",
			queries = "queries/nvim",
		},
		tier = 2,
	}
end

register_parser()
vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	group = vim.api.nvim_create_augroup("crystal-treesitter-parser", { clear = true }),
	callback = register_parser,
})

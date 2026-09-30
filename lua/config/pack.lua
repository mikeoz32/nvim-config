--- @param repo string
local gh = function(repo)
	return "https://github.com/" .. repo
end


vim.pack.add({
	-- colorscheme
	gh("catppuccin/nvim"),

	-- syntax highlighting + навігація по AST (функції/класи)
	-- main, а не master: master несумісний з Neovim 0.12 (падає на markdown code-fence і python subscript)
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
	gh("echasnovski/mini.ai"),

	-- completion
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.10") },
	gh("rafamadriz/friendly-snippets"),

	-- fuzzy finder
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope.nvim"),

	-- file explorer
	gh("nvim-tree/nvim-tree.lua"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("folke/trouble.nvim"),

	-- git
	gh("lewis6991/gitsigns.nvim"),
	gh("NeogitOrg/neogit"),
	gh("sindrets/diffview.nvim"),

	-- terminal
	gh("akinsho/toggleterm.nvim"),

	-- підказки клавіш
	gh("folke/which-key.nvim"),

	-- statusline
	gh("nvim-lualine/lualine.nvim"),

	-- zen mode
	gh("folke/zen-mode.nvim"),
}, { confirm = false })

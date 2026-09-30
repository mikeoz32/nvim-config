require("lualine").setup({
	options = {
		theme = "catppuccin",
		icons_enabled = true,
		always_show_tabline = true,
	},
	tabline = {
		lualine_a = {
			{
				"buffers",
				show_filename_only = true,
				show_modified_status = true,
				mode = 0,
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "nvim-tree" },
})

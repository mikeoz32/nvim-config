require("trouble").setup({
	modes = {
		symbols = {
			-- Keep every symbol returned by the LSP, including variables and fields.
			filter = function(items)
				return items
			end,
		},
	},
})

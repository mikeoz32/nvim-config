vim.filetype.add({
	extension = {
		cr = "crystal",
	},
	filename = {
		["shard.yml"] = "yaml",
		["shard.lock"] = "yaml",
		["shard.override.yml"] = "yaml",
	},
})

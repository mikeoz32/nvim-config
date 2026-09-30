vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>db", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("n", "<leader>gt", "<cmd>Neogit<cr>", { desc = "Toggle Neogit" })
map("n", "<leader>gb", function()
	require("gitsigns").toggle_linehl()
end, { desc = "Toggle changed line highlights" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>df", "<cmd>Telescope live_grep<cr>", { desc = "Grep project" })
map("n", "<leader>ds", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Toggle code symbols tree" })
map("n", "<leader>cc", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle diagnostics" })
map("n", "<leader>cr", "<cmd>Trouble lsp_references toggle focus=false<cr>", { desc = "LSP references" })

map("n", "<leader>fw", "<cmd>w<cr>", { desc = "Write file" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

map("n", "<leader>bs", "<cmd>Telescope buffers<cr>", { desc = "Search buffers" })

map("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd("bprevious")
	vim.cmd("bdelete " .. buf)
end, { desc = "Delete buffer, show previous" })

map("n", "<leader>wh", "<C-w>h", { desc = "Focus window left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus window up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus window right" })

map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("n", "<leader>tn", "<cmd>TermNew direction=horizontal size=15 name=Shell<cr>", { desc = "New terminal" })
map("n", "<leader>ts", "<cmd>TermSelect<cr>", { desc = "Select terminal" })
local codex_terminal
local function toggle_codex()
	if not codex_terminal then
		local Terminal = require("toggleterm.terminal").Terminal
		codex_terminal = Terminal:new({
			cmd = "codex",
			display_name = "Codex",
			dir = vim.fn.getcwd(),
			direction = "horizontal",
			size = 15,
		})
	end
	codex_terminal:toggle()
end
map({ "n", "t" }, "<leader>act", toggle_codex, { desc = "Toggle Codex" })
map("n", "<leader>zz", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode" })
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

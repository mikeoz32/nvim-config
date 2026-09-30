local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

-- один statusline на все вікно (не свій у кожного спліту/nvim-tree)
opt.laststatus = 3

opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false

opt.splitright = true
opt.splitbelow = true

opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300

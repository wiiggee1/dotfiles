local set = vim.opt
local exec = vim.api.nvim_exec

-- Editor settings
set.number = true
set.relativenumber = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.autoindent = true
set.smartindent = true 
set.ignorecase = true
set.smartcase = true
set.linebreak = true

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.smarttab = true
vim.opt.breakindent = true
-- vim.opt.mouse = "n"
vim.opt.mouse = ""

-- Disable Arrow keys for motion practice
vim.api.nvim_set_keymap('i', '<Up>', "<C-o>: echo 'Up arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Down>', "<C-o>: echo 'Down arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Left>', "<C-o>: echo 'Left arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('i', '<Right>', "<C-o>: echo 'Right arrow key disabled'<CR>", {noremap = true, silent = false })

vim.api.nvim_set_keymap('n', '<Up>', "<C-o>: echo 'Up arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Down>', "<C-o>: echo 'Down arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Left>', "<C-o>: echo 'Left arrow key disabled'<CR>", {noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<Right>', "<C-o>: echo 'Right arrow key disabled'<CR>", {noremap = true, silent = false })

-- To navigate in the lsp.buf window use: CTRL + j - DOWN and CTRL + k for UP. 
-- Pressing "A" would move to the end of the line. 

-- Cursor settings
set.cursorline = true

-- Appearance
set.termguicolors = true

-- clipboard
set.clipboard:append("unnamedplus")

-- Editor view 
set.splitright = true
set.splitbelow = true


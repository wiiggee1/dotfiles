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
vim.opt.mouse = "n"

-- Cursor settings
set.cursorline = true

-- Appearance
set.termguicolors = true

-- clipboard
set.clipboard:append("unnamedplus")

-- Editor view 
set.splitright = true
set.splitbelow = true


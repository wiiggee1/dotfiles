-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

--TODO: 
-- * Fix the keybinding for toggle nvim-tree in the nvim-tree.view buffer

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  update_cwd = true,
  hijack_cursor = true,
  view = {
    adaptive_size = false,
    signcolumn = "no",
    width = 20,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    full_name = true, 
    highlight_git = true,
    special_files = {},
    symlink_destination = false,
    indent_markers = {
        enable = true,
    },
    group_empty = true,
  },
  diagnostics = {
      enable = true,
      show_on_dirs = false,
  },
  filters = {
    dotfiles = true,
  },
})




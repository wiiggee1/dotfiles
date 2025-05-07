return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {'nvim-tree/nvim-web-devicons'},

        config = function ()
           -- OR setup with some options
            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                update_cwd = true,
                hijack_cursor = true,
                view = {
                    adaptive_size = false,
                    signcolumn = "no",
                    width = 20,
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
        end
    }
}

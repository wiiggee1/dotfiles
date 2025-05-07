return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                height = 10,
                icons = false,
                mode = "workspace_diagnostics",
                padding = true, -- add an extra new line on top of the list
                cycle_results = true,
                auto_preview = true,
                  -- your configuration comes here
                  -- or leave it empty to use the default settings
                  -- refer to the configuration section below
                fold_open = "v", -- icon used for open folds
                fold_closed = ">", -- icon used for closed folds
                indent_lines = true, -- add an indent guide below the fold icons
                signs = {
                    error = "error",
                    warning = "warn",
                    hint = "hint",
                    information = "info"
                },
                auto_open = false,  -- Automatically open the trouble list on error
                auto_close = false, -- Automatically close the trouble list when it's empty
                use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
            }
        end
    },
}


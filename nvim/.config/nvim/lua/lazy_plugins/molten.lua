return {
    {
        "benlubas/molten-nvim",
        dev = false,
        enabled = true,
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        dependencies = { "3rd/image.nvim" },
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
            vim.g.molten_auto_open_output = true
            vim.g.molten_auto_open_html_in_browser = true
            vim.g.molten_tick_rate = 200
        end,
        config = function()
            local init = function()
                local quarto_cfg = require('quarto.config').config
                quarto_cfg.codeRunner.default_method = 'molten'
                vim.cmd [[MoltenInit]]
            end
            local deinit = function()
                local quarto_cfg = require('quarto.config').config
                quarto_cfg.codeRunner.default_method = 'slime'
                vim.cmd [[MoltenDeinit]]
            end

            vim.keymap.set("n", "<leader>mi", function()
              local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
              if venv ~= nil then
                -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
                venv = string.match(venv, "/.+/(.+)")
                vim.cmd(("MoltenInit %s"):format(venv))
              else
                vim.cmd("MoltenInit python3")
              end
            end, { desc = "Initialize Molten for python3", silent = true })

            -- vim.keymap.set('n', '<leader>mi', init, { silent = true, desc = 'Initialize molten' })
            vim.keymap.set('n', '<leader>md', deinit, { silent = true, desc = 'Stop molten' })
            vim.keymap.set('n', '<leader>mip', ':MoltenImagePopup<CR>', { silent = true, desc = 'molten image popup' })
            vim.keymap.set('n', '<leader>mb', ':MoltenOpenInBrowser<CR>',
            { silent = true, desc = 'molten open in browser' })
            vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'hide output' })
            vim.keymap.set('n', '<leader>ms',':noautocmd MoltenEnterOutput<CR>',
            { silent = true, desc = 'show/enter output' })
        end,
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            -- backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    }
}

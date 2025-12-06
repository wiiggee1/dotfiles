return{
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "nvim-lspconfig",
            "jmbuhr/otter.nvim",
        },
        dev = false,
        opts = {
            lspFeatures = {
                enabled = true,
                chunks = 'curly',
                languages = { "python", "rust", "bash", "html", "lua" },
                diagnostics = {
                    enabled = true,
                    triggers = { "BufWritePost" },
                },
                completion = {
                    enabled = true,
                },
            },
            codeRunner = {
                enabled = true,
                -- default_method = 'slime',
                default_method = "molten",
                -- ft_runners = { python = "molten"},
            },
        },
    },
    {
        'jmbuhr/otter.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {},
    },
    { -- directly open ipynb files as quarto docuements
        -- and convert back behind the scenes
        'GCBallesteros/jupytext.nvim',
        config = true,
        opts = {
            -- style = 'quarto',
            -- extension = 'qmd',
            -- output_extension = "auto",
            -- force_ft = 'quarto',
            custom_language_formatting = {
                python = {
                    extension = 'qmd',
                    style = 'quarto',
                    force_ft = 'quarto',
                },
            },
        },
    },
    {
        -- send code from python/r/qmd documets to a terminal or REPL
        -- like ipython, R, bash
        'jpalardy/vim-slime',
        dev = false,
        init = function()
            vim.b['quarto_is_python_chunk'] = false
            Quarto_is_in_python_chunk = function()
                require('otter.tools.functions').is_otter_language_context 'python'
            end

            vim.cmd [[
              let g:slime_dispatch_ipython_pause = 100
              function SlimeOverride_EscapeText_quarto(text)
              call v:lua.Quarto_is_in_python_chunk()
              if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
              return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
              else
              if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
              return [a:text, "\n"]
              else
              return [a:text]
              end
              end
              endfunction
              ]]

              vim.g.slime_target = 'neovim'
              vim.g.slime_no_mappings = true
              vim.g.slime_python_ipython = 1
        end,
        config = function()
            vim.g.slime_input_pid = false
            vim.g.slime_suggest_default = true
            vim.g.slime_menu_config = false
            vim.g.slime_neovim_ignore_unlisted = true

            local function mark_terminal()
                local job_id = vim.b.terminal_job_id
                vim.print('job_id: ' .. job_id)
            end

            local function set_terminal()
                vim.fn.call('slime#config', {})
            end
            vim.keymap.set('n', '<leader>cm', mark_terminal, { desc = '[m]ark terminal' })
            vim.keymap.set('n', '<leader>cs', set_terminal, { desc = '[s]et terminal' })
        end,
    },
    { -- paste an image from the clipboard or drag-and-drop
        'HakonHarnes/img-clip.nvim',
        event = 'BufEnter',
        ft = { 'markdown', 'quarto', 'latex' },
        opts = {
            default = {
                dir_path = 'img',
            },
            filetypes = {
                markdown = {
                  url_encode_path = true,
                  template = '![$CURSOR]($FILE_PATH)',
                  drag_and_drop = {
                    download_images = false,
                  },
                },
                quarto = {
                  url_encode_path = true,
                  template = '![$CURSOR]($FILE_PATH)',
                  drag_and_drop = {
                    download_images = false,
                  },
                },
            },
        },
        config = function(_, opts)
            require('img-clip').setup(opts)
            vim.keymap.set('n', '<leader>ii', ':PasteImage<cr>', { desc = 'insert [i]mage from clipboard' })
        end,
    },
    {
        -- preview equations
        'jbyuki/nabla.nvim',
        dependencies = {
            "nvim-neo-tree/neo-tree.nvim",
            -- { "nvim-neo-tree/neo-tree.nvim", opts = {} },
            "mason-org/mason.nvim",
            -- "williamboman/mason.nvim",
            "benlubas/molten-nvim",
        },
        lazy = true,

    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
    },
}

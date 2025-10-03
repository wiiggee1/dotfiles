return {
    {
		"neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
	    dependencies = {
		  -- LSP Support
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = '${3rd}/luv/library', words = { 'vim%.uv' } }
                    },
                },
            },
            { 'mason-org/mason.nvim', opts = {} },
            {
                'mason-org/mason-lspconfig.nvim',
                opts = {},
                dependencies = {
                    { "mason-org/mason.nvim", opts = {} },
                    "neovim/nvim-lspconfig",
                },
            },
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            "folke/neodev.nvim",

		  -- Autocompletion
		    'hrsh7th/nvim-cmp',
		    'hrsh7th/cmp-buffer',
		    'hrsh7th/cmp-path',
		    'saadparwaiz1/cmp_luasnip',
		    'hrsh7th/cmp-nvim-lsp',
		    'hrsh7th/cmp-nvim-lua',

		    -- Snippets
		    'L3MON4D3/LuaSnip',
            { 'j-hui/fidget.nvim', opts = {} },

            'onsails/lspkind.nvim', -- vs-code like icons for autocompletion
	    },

        config = function ()
            local cmp = require('cmp')
            require("fidget").setup()
            -- local cmp_lsp = require("cmp_nvim_lsp")

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend(
                'force',
                capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0

            -- vim.lsp.config("*", {
            --     capabilities = capabilities,
            -- })

            local servers = {
                -- vim.lsp.config("zls", {
                zls = {
                    -- capabilities = capabilities,
                    filetypes = { "zig", "zon", "zir" },
                    cmd = {"zls"},
                    workspace_required = false,
                    root_markers = { "zls.json", "build.zig", ".git" },

                    settings = {
                        zls = {
                            enable_inlay_hints = true,
                            enable_snippets = true,
                            semantic_tokens = "full",
                            enable_build_on_save = true,
                            build_on_save_step = "check",
                            build_on_save_args = {"check", "fincremental", "-freference-trace=10"},
                        },
                    },
                },
                -- vim.lsp.config("pylsp", {
                pylsp = {
                    -- capabilities = default_capabilities,
                    -- filetypes = {"python"},
                    settings = {
                        pylsp = {
                            plugins = {
                                pyflakes = { enabled = false },
                                pycodestyle = {
                                    ignore = {'W391'},
                                    maxLineLength = 100,
                                },
                                autopep8 = { enabled = false },
                                yapf = { enabled = false },
                                mccabe = { enabled = false },
                                pylsp_mypy = { enabled = false },
                                pylsp_black = { enabled = false },
                                pylsp_isort = { enabled = false },

                            },
                        },
                    },
                },
                -- vim.lsp.config("clangd", {
                clangd = {
                        cmd = {
                           "clangd",
                           "--clang-tidy",
                            "--completion-style=detailed",
                        },
                        filetypes = {'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto'},
                },

                -- vim.lsp.config("lua_ls", {
                lua_ls = {
                        cmd = { "lua-language-server" },
                        -- capabilities = default_capabilities,
                },

                -- vim.lsp.config("rust_analyzer", {
                rust_analyzer = {
                        -- capabilities = default_capabilities,
                        -- on_attach = lsp_attach,
                        settings = {
                            ['rust_analyzer'] = {},
                        }
                },
                bashls = true,

                -- vim.lsp.config("texlab", {
                texlab = {
                    -- capabilities = default_capabilities,
                    setting = {
                        texlab = {
                            forwardSearch = {
                                executable = 'zathura',
                                args = {
                                    '--synctex-editor-command',
                                    [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
                                    '--synctex-forward',
                                    '%l:1:%f',
                                    '%p',
                                },
                            },
                        },
                    },
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',
            })

            require('mason-tool-installer').setup{
                ensure_installed = ensure_installed,
                auto_update = false,
                run_on_start = true,
                integrations = {
                    ['mason-lspconfig'] = true,
                    ['mason-null-ls'] = true,
                    ['mason-nvim-dap'] = true,
                },
            }

            -- vim.lsp.config("*", {
            --     capabilities = capabilities,
            -- })

            for server, conf in pairs(servers) do
                if conf == true then
                    conf = {}
                end
                conf = vim.tbl_deep_extend(
                    "force",
                    {},
                    { capabilities = capabilities },
                    conf
                )

                vim.lsp.config(server, conf)
                vim.lsp.enable(server)
            end

            -- vim.lsp.enable({
            --     "rust_analyzer",
            --     "clangd",
            --     "lua_ls",
            --     "bashls",
            --     "zls",
            --     "texlab",
            --     "pylsp",
            -- })

            -- require('mason-lspconfig').setup({
            --     --     ensure_installed = {'rust_analyzer', 'clangd', 'lua_ls', 'bashls', 'zls', 'texlab', 'pylsp'},
            --     ensure_installed = {},
            --     automatic_installation = false,
            --     handlers = {
            --         -- ===HOW TO ADD===
            --         function(server_name) -- default handler (optional)
            --             require("lspconfig")[server_name].setup {
            --                 capabilities = capabilities
            --             }
            --         end,
            --     }
            -- })


            -- DIAGNOSTIC CONFIGURATION: 
            vim.diagnostic.config({
                underline = true,
                -- virtual_text = false,
                virtual_text = {
                    spacing = 2,
                },
                severity_sort = true,
                float = {
                    style = 'minimal',
                    border = 'rounded',
                    source = "always",
                    header = '',
                    prefix = '',
                  },
            })

            require('luasnip').config.set_config({
                region_check_events = 'InsertEnter',
                delete_check_events = 'InsertLeave'
            })
            require('luasnip.loaders.from_vscode').lazy_load()
            local lspkind = require('lspkind')

            -- vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.close(), -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({select = false }),
                }),
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'},
                    {name = 'buffer'},
                    {name = 'path'}, -- file system paths
                    {name = 'luasnip'}, -- snippets
                    {name = 'nvim_lua'},
                }),
                view = {
                    entries = "custom",
                    selection_order = "top_down",
                },
                window = {
                    completion = {
                        border = 'double',
                    },
                    documentation = {
                        border = 'rounded',
                        format = {}
                    },
                },
                completion = {
                    completeopt = "menu, menuone, noselect",
                },
                formatting = {
                    fields = {'kind', 'abbr', 'menu'},
                    format = require('lspkind').cmp_format({
                        mode = 'symbol_text', -- show only symbol annotations
                        maxwidth = 40, -- prevent the popup from showing more than provided characters
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
                        before = function(entry, vim_item)
                            -- add customization before lspkind
                            vim_item.menu = ({
                                buffer = "[Buff]",
                                nvim_lsp = "[LSP]",
                                luasnip = "[LuaSnip]",
                                nvim_lua = "[Lua]",
                                latex_symbols = "[Latex]",
                            })[entry.source.name]

                            vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }

                            return vim_item
                        end
                    })
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
        })
        end
    },
}

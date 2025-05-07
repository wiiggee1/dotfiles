return {
		"neovim/nvim-lspconfig",
	    dependencies = {
		  -- LSP Support
            'williamboman/mason.nvim',
		    'williamboman/mason-lspconfig.nvim',

		  -- Autocompletion
		    'hrsh7th/nvim-cmp',
		    'hrsh7th/cmp-buffer',
		    'hrsh7th/cmp-path',
		    'saadparwaiz1/cmp_luasnip',
		    'hrsh7th/cmp-nvim-lsp',
		    'hrsh7th/cmp-nvim-lua',

		    -- Snippets
		    'L3MON4D3/LuaSnip',
            'j-hui/fidget.nvim',

            'onsails/lspkind.nvim', -- vs-code like icons for autocompletion
	    },

        config = function ()
            local lspconfutil = require('lspconfig/util')
            local root_pattern = lspconfutil.root_pattern("veridian.yml", ".git")
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local lsp_config = require('lspconfig')

            require("fidget").setup({})
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {'rust_analyzer', 'clangd', 'lua_ls', 'bashls', 'ts_ls', 'zls'},
                handlers = {
                    -- ===HOW TO ADD===
                    -- function(server_name) -- default handler (optional)
                    --     require("lspconfig")[server_name].setup {
                    --         capabilities = capabilities
                    --     }
                    -- end,

                    zls = function()
                        -- local lspconfig = require("lspconfig")
                        lsp_config.zls.setup({
                            capabilities = default_capabilities,
                            root_dir = lsp_config.util.root_pattern(".git", "build.zig", "zls.json"),
                            cmd = {'/home/wiiggee1/zls/zig-out/bin/zls'},

                            settings = {
                                zls = {
                                    enable_inlay_hints = true,
                                    enable_snippets = true,
                                    warn_style = true,
                                    semantic_tokens = "full",
                                    enable_build_on_save = true,
                                    -- build_on_save_step = "check",
                                    zig_lib_path = "/home/wiiggee1/zig_versions/zig-relsafe-espressif-x86_64-linux-musl-baseline/lib/",
                                    zig_exe_path = "/home/wiiggee1/zig_versions/zig-relsafe-espressif-x86_64-linux-musl-baseline/zig",
                                    --cmd = { '/usr/bin/zls' },
                                },
                            },
                        })
                        vim.g.zig_fmt_parse_errors = 0
                        vim.g.zig_fmt_autosave = 0

                    end,

                    clangd = function ()
                       require('lspconfig').clangd.setup({
                            cmd = {
                               "clangd",
                               "--clang-tidy",
                                "--completion-style=detailed",
                            },
                            filetypes = {'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto'},
                        })
                    end,

                    lua_ls = function ()
                        require('lspconfig').lua_ls.setup({
                            capabilities = default_capabilities,
                        })
                    end,

                    rust = function ()
                        -- require('lspconfig').rust_analyzer.setup({})
                        lsp_config.rust_analyzer.setup({
                            capabilities = default_capabilities,
                            -- on_attach = lsp_attach,
                            settings = {
                                ['rust_analyzer'] = {},
                            }
                        })
                    end,

                    verible = function()
                        require('lspconfig').verible.setup({
                            -- on_attach = lsp_zero.on_attach,
                            cmd = { "verible-verilog-ls" },
                            filetypes = { 'systemverilog', 'verilog' },
                            root_dir = require("lspconfig.util").root_pattern(".git"),
                            single_file_support = true,
                        })
                    end,
                },
            })
            -- DIAGNOSTIC CONFIGURATION: 
            vim.diagnostic.config({
                underline = true,
                virtual_text = false,
                -- virtual_text = {
                --     spacing = 2,
                -- },
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

}

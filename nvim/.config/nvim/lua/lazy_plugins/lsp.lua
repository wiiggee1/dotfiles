return {
		"neovim/nvim-lspconfig",
        event = {"BufReadPre", "BufNewFile"},
	    dependencies = {
		  -- LSP Support
            'williamboman/mason.nvim',
		    'williamboman/mason-lspconfig.nvim',

            "folke/neodev.nvim",
            "saghen/blink.cmp",

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
            local cmp = require('cmp')
            -- local cmp_lsp = require("cmp_nvim_lsp")
            local lsp_config = require('lspconfig')
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local status_flag, blink = pcall(require, "blink.cmp")
            if status_flag then
                capabilities = vim.tbl_deep_extend(
                    "force",
                    capabilities,
                    blink.get_lsp_capabilities()
                    -- require("cmp_nvim_lsp").default_capabilities()
                )
            end

            require("fidget").setup()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {'rust_analyzer', 'clangd', 'lua_ls', 'bashls', 'ts_ls', 'zls', 'texlab'},
                handlers = {
                    -- ===HOW TO ADD===
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    zls = function()
                        lsp_config.zls.setup({
                            capabilities = capabilities,
                            -- filetypes = { "zig", "zon" },
                            -- cmd = vim.fn.expand("~/zls/zig-out/bin/zls"),
                            -- cmd = {"zls"},
                            workspace_required = false,
                            root_dir = lsp_config.util.root_pattern(".git", "build.zig", "zls.json"),

                            settings = {
                                zls = {
                                    enable_inlay_hints = true,
                                    enable_snippets = true,
                                    -- warn_style = true,
                                    -- enable_argument_placeholders = false,
                                    -- semantic_tokens = "full",
                                    semantic_tokens = "full",
                                    enable_build_on_save = true,
                                    build_on_save_step = "check",
                                    -- -freference-trace=10
                                    -- build_on_save_args = {"check", "fincremental"},
                                    build_on_save_args = {"check", "fincremental", "-freference-trace=10"},
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

                    texlab = function ()
                        local executable = 'zathura'
                        local args = {
                            '--synctex-editor-command',
                            [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
                            '--synctex-forward',
                            '%l:1:%f',
                            '%p',
                        }
                        require('lspconfig').texlab.setup({
                        capabilities = default_capabilities,
                        setting = {
                            texlab = {
                                forwardSearch = {
                                    executable = executable,
                                    args = args,
                                },
                            },
                        },
                    })
                    end,
                },
            })
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
}

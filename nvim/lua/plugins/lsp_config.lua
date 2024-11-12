-- Configure LSP servers

--require'lspconfig'.sumneko_lua.setup()
local lsp_zero = require('lsp-zero')
lsp_zero.preset("recommended")

--TODO: 
-- * Fix floating "Go to definition" for the current buffer.

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local lspconfutil = require 'lspconfig/util'
local root_pattern = lspconfutil.root_pattern("veridian.yml", ".git")

require('lspconfig').veridian.setup {
    cmd = { 'veridian' },
    filetypes = {'systemverilog', 'verilog'},
    root_dir = root_pattern,
    single_file_support = true,
}

require('lspconfig').svlangserver.setup{
    cmd = { "svlangserver" },
    filetypes = { "verilog", "systemverilog" },
    root_dir = require("lspconfig.util").root_pattern("veridian.yml", ".git"),
    single_file_support = true,
}

require('lspconfig').rust_analyzer.setup({})

require('lspconfig').lua_ls.setup{}

require('lspconfig').clangd.setup{
    cmd = {
       "clangd",
       "--clang-tidy",
		"--background-index",
		"--completion-style=detailed",
    }
}

--require('java').setup()
require('lspconfig').jdtls.setup({})

--require('lspconfig').verible.setup{
  --  on_attach = lsp_zero.on_attach,
   -- flags = lsp_flags,
   -- root_dir = require("lspconfig.util").root_pattern(".git")
--}


lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = ''
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'rust_analyzer', 'clangd', 'lua_ls', 'bashls', 'ts_ls'},
    handlers = {
        lsp_zero.default_setup,

        -- look at documentations: https://lsp-zero.netlify.app/v3.x/getting-started.html
      verible = function()
            require('lspconfig').verible.setup({
                on_attach = lsp_zero.on_attach,
                cmd = { "verible-verilog-ls" },
                filetypes = { 'systemverilog', 'verilog' },
                root_dir = require("lspconfig.util").root_pattern(".git"),
                single_file_support = true,
            })
        end,
    },
})

--autocmd BufWritePost *.v lua vim.lsp.buf.format({ async = false })

vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  severity_sort = false,
  float = {
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})


---
-- Snippet config
---

require('luasnip').config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
})

require('luasnip.loaders.from_vscode').lazy_load()

---
-- Autocompletion
---

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
--local cmp_config = require('lsp-zero').defaults.cmp_config({})

--cmp.setup(cmp_config)
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
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'path'}, -- file system paths
        {name = 'luasnip'}, -- snippets
        {name = 'nvim_lua'},
        
    },
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
            format = { 
            }
            
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

-- Turn on lsp status information
require('fidget').setup()

lsp_zero.setup()


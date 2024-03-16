-- Configure LSP servers

--require'lspconfig'.sumneko_lua.setup()
local lsp_zero = require('lsp-zero')
lsp_zero.preset("recommended")

--require('mason').setup()
--require('mason-lspconfig').setup()
--require("mason-nvim-dap").setup()

--local get_servers = require('mason-lspconfig').get_installed_servers
--for _, server_name in ipairs(get_servers()) do
--    require('lspconfig')[server_name].setup({})
--end

--TODO: 
-- * Fix floating "Go to definition" for the current buffer.

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

--lsp-zero.set_sign_icons()
--vim.diagnostic.config(require('lsp-zero').defaults.diagnostics({}))

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = ''
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'rust_analyzer', 'clangd', 'lua_ls', 'bashls', 'tsserver'},
    handlers = {
        lsp_zero.default_setup,
    },
})

vim.diagnostic.config({
  underline = true,
  virtual_text = true,
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


-- old 
--cmp_config.mapping = cmp.mapping.preset.insert({
--    ['<C-k>'] = cmp.mapping.select_prev_item(),
--    ['<C-j>'] = cmp.mapping.select_next_item(),
--    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-Space>'] = cmp.mapping.complete(),
--    ['<C-e>'] = cmp.mapping.close(),
--    ['<CR>'] = cmp.mapping.confirm { select = false }
--})

--lsp_zero.setup_nvim_cmp({
--    mapping = cmp_config.mapping
--})

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
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    completion = {
        completeopt = "menu, menuone, noselect",
    },
    formatting = {
        fields = {'kind', 'abbr', 'menu'},
        format = require('lspkind').cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 30, -- prevent the popup from showing more than provided characters
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
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



vim.lsp.config['luals'] = {
    -- Command and arguments to start the server.
    cmd = { 'lua-language-server' },

    -- Filetypes to automatically attach to.
    filetypes = { 'lua' },

    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a ".luarc.json" or a
    -- ".luarc.jsonc" file. Files that share a root directory will reuse
    -- the connection to the same LSP server.
    root_markers = { '.luarc.json', '.luarc.jsonc' },

    -- Specific settings to send to the server. The schema for this is
    -- defined by the server. For example the schema for lua-language-server
    -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        }
      }
    }
}

vim.lsp.config.clangd = {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({'luals', 'clangd', 'gopls', 'rust-analyzer'})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

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
    source = 'always',
    header = '',
    prefix = '',
  },
})



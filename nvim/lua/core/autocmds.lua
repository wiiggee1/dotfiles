-- Auto reloading neovim session listening for event whenever buffer is being written to
local autocmd = vim.api.nvim_create_autocmd



autocmd('BufWritePost', {
    command = 'so'
})

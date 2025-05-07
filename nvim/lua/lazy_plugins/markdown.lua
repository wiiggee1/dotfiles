return {
    {
        -- Markdown plugin. 
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'echasnovski/mini.nvim' },
        config = function()
            require('render-markdown').setup({})
        end,
    },
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    --     ft = { "markdown" },
    --     build = function() vim.fn["mkdp#util#install"]() end,
    -- },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && npm install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     build = "cd app && npm install",
    --     config = function()
    --         vim.g.mkdp_filetypes = { "markdown" }
    --     end,
    --     ft = { "markdown" },
    -- },
}

return {
    {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        -- event = "BufRead *.tex",
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.cmd[[let g:vimtex_view_general_viewer = 'zathura']]
            vim.g.vimtex_view_method  = 'zathura'
            -- vim.g.vimtex_context_pdf_viewer = 'okular'     -- External PDF viewer for the Vimtex menu
            -- vim.cmd[[let g:vimtex_compiler_method = 'latexrun']]
            vim.cmd[[let g:tex_flavor='latex']]
            vim.cmd[[let g:vimtex_quickfix_mode=0]]
            vim.cmd[[set conceallevel=1]]
            vim.cmd[[let g:tex_conceal='abdmg']]

            vim.g.vimtex_compiler_latexmk = {
                aux_dir = '',
                out_dir = '',
                callback = 1,
                continuous = 1,
                executable = 'latexmk',
                hooks = {},
                options = {
                    '-pdf',
                    '-shell-escape',
                    '-verbose',
                    '-file-line-error',
                    '-synctex=1',
                    '-interaction=nonstopmode',
               },
            }
        end
    },
    {
        'f3fora/nvim-texlabconfig',
        config = function()
            local config_default = {
                cache_activate = true,
                cache_filetypes = { 'tex', 'bib' },
                cache_root = vim.fn.stdpath('cache'),
                reverse_search_start_cmd = function()
                    return true
                end,
                reverse_search_edit_cmd = vim.cmd.edit,
                reverse_search_end_cmd = function()
                    return true
                end,
                file_permission_mode = 438,
            }
            require('texlabconfig').setup(config_default)
        end,
        -- ft = { 'tex', 'bib' }, -- Lazy-load on filetype
        build = 'go build'
        -- build = 'go build -o ~/.bin/' -- if e.g. ~/.bin/ is in $PATH
    }
}

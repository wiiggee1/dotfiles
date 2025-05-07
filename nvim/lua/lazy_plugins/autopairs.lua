return{
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function

        config = function()
            -- require("nvim-autopairs").setup {}
            local npairs = require("nvim-autopairs")
            local Rule = require('nvim-autopairs.rule')
            local ts_conds = require('nvim-autopairs.ts-conds')

            npairs.enable()
            npairs.setup({
                check_ts = true,
                ts_config = {
                }
            })
        end
    }
}

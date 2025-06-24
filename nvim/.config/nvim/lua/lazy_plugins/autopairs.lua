return{
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function

        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require('nvim-autopairs.rule')
            npairs.enable()
            npairs.setup({
                check_ts = true,
                ts_config = {
                }
            })
        end
    }
}

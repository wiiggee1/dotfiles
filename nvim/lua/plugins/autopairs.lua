local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')
local ts_conds = require('nvim-autopairs.ts-conds')
npairs.enable()

npairs.setup({
    check_ts = true,
    ts_config = {
        -- zig = true,
    }
})

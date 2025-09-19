return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function ()
            local M = require("catppuccin.utils.colors")
            require("catppuccin").setup({
                flavour = "frappe", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    -- dark = "mocha", --dark = "mocha"
                    dark = "frappe", --dark = "mocha"
                },
                auto_integrations = true,
                transparent_background = true, --my defualt: true
                show_end_of_buffer = false,
                term_colors = true, -- my default: true
                dim_inactive = {
                    enabled = true, -- my default: true
                    shade = "dark",
                    percentage = 0.40, -- my default: 0.20
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {"bold"},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {
                    -- all = {
                    --     base = "#303446",
                    --     crust = "#f8f8ff",
                    --     mantle = "#2c2c2e",
                    -- }
                },
                -- custom_highlights = {},
                custom_highlights = function(colors)
                    -- @variable.lua links to @variable
                    return {
                        ["@property"] = { fg = colors.lavender },
                        -- ["@variable"] = { fg = "#f8f8ff" }, -- #f8f8ff - ghost white
                        ["@variable"] = { fg = M.darken("#f8f8ff", 0.15, "#f8f8ff") }, -- #f8f8ff - ghost white
                        ["@lsp.type.namespace.zig"] = { fg = colors.flamingo }, --colors.flamingo
                        ["@lsp.type.declaration.zig"] = { fg = colors.yellow },
                        ["@lsp.type.property.zig"] = { fg = colors.lavender },
                        ["@lsp.typemod.namespace.declaration.zig"] = { fg = colors.maroon },
                        Keyword = { fg = "#D8ABE5"},
                        Type = { fg = colors.yellow},
                        -- Comment = { fg = colors.flamingo },
                        TabLineSel = { bg = colors.pink },
                        CmpBorder = { fg = colors.surface2 },
                        Pmenu = { bg = colors.none },
                    }
                end,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    mason = true,
                    nvimtree = true,
                    render_markdown = true,
			        semantic_tokens = true,
                    treesitter = true,
                    treesitter_context = true,
                    telescope = true,
                    notify = true,
                    mini = true,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
                indent_blankline = {
                    enabled = true
                },
            })
            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"
        end

--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    }
}


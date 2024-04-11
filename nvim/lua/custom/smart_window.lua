local api = vim.api
local cmd = vim.cmd

local SmartWindow = {}

function SmartWindow.create_window()
    -- Do something
    print("Hello new Plugin!")
    vim.print("Hello new Plugin!")
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {"test", "text"})

    local opts = {
        relative = "cursor",
        width = 10,
        height = 2, 
        col = 0,
        row = 1,
        anchor = "NW",
        style = "minimal"
    }

    local window = vim.api.nvim_open_win(buf, 0, opts)


end

return SmartWindow
---return SmartWindow.create_window()


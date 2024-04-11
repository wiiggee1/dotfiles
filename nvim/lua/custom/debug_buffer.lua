local debug_buffer = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_name(debug_buffer, "Debug Info")

print("Enter the path to the executable to debug:")
local exec_path = io.read()

local debug_window = vim.api.nvim_open_win(debug_buffer, true, {
    relative = 'editor',
    width = vim.api.nvim_get_option("columns"),
    height = vim.api.nvim_get_option("lines") / 2,
    row = 0,
    col = 0,
    style = "minimal",
    border = "single",
})

-- Function to update GDB information
local function update_gdb_info()
    -- Execute GDB command asynchronously and capture output
    local cmd = string.format("gdb --batch --ex 'info registers' %s", exec_path)
    local handle = vim.loop.spawn(cmd, {
        stdio = {nil, true, true},
    }, function(code, _)
        if code == 0 then
            -- Read GDB output from stdout
            vim.loop.read_start(handle.stdout, function(err, data)
                assert(not err, err)
                if data then
                    -- Convert data to string and split lines
                    local gdb_output = vim.split(data, '\n')
                    
                    -- Clear the buffer
                    vim.api.nvim_buf_set_lines(debug_buffer, 0, -1, false, {})
                    
                    -- Insert the GDB output into the buffer
                    vim.api.nvim_buf_set_lines(debug_buffer, 0, -1, false, gdb_output)
                end
            end)
        else
            print("Error: GDB command failed")
        end
    end)
end

-- Set up an autocmd to update GDB information when the window is entered
vim.api.nvim_command("autocmd BufEnter <buffer> lua update_gdb_info()")

-- Initial update of GDB information
update_gdb_info()

        


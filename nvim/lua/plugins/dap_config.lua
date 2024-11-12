require("dapui").setup()
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
  })

local dap, dapui = require("dap"), require("dapui")
require('dap').set_log_level('DEBUG')
require('dap').set_log_level('ERROR')


dapui.setup()


dap.adapters.gdb = {
  type = "executable",
  command = "arm-none-eabi-gdb",
  --command = "gdb", 
  --args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  --args = { "--interpreter=dap", "-q", "-x", "openocd.gdb" }
  args = {"--interpreter=mi2", "-q", "-x", "openocd.gdb" }

}

--if not dap.adapters then dap.adapters = {} end
--dap.adapters["probe-rs-debug"] = {
--  type = "server",
--  port = "${port}",
--  executable = {
--    command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
--    args = { "dap-server", "--port", "${port}" },
--  },
--}

dap.configurations.rust = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function ()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        --stopAtBeginningOfMainSubprogram = false, 
        stopOnEntry = false,
    },
    {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
       local name = vim.fn.input('Executable name (filter): ')
       return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :3333',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:3333',
    program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
    --stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.rust


--[[
dapui.setup({
icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
})
]]



--dap.configurations.cpp = {
--    {
--      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
--      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--      name = "Launch file",
--      type = 'codelldb',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
--      request = 'launch',
--      program = function()
--      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--    end,
--    cwd = vim.fn.getcwd(),
--    stopOnEntry = false,
--    }
--}

vim.keymap.set("n", "<Leader>dt", ':lua require("dapui").toggle()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>db", ':lua require"dap".toggle_breakpoint()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dc", ':lua require"dap".continue()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>du", ':lua require"dap".step_over()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>di", ':lua require"dap".step_into()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>do", ':lua require"dap".step_out()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dr", ':lua require"dap".repl.toggle()<CR>', {noremap=true})
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)

--print(vim.inspect(dap.configurations))


-- Start OpenOCD in a Neovim terminal
local function start_openocd()
    local cwd = vim.fn.getcwd()
    --local config_path = cwd .. "/openocd.cfg"
    --vim.fn.termopen("openocd -f " .. config_path)
    --vim.fn.termopen("openocd -f openocd.cfg")
    --os.execute("openocd -f openocd.cfg")
end

-- Stop OpenOCD by killing the process
local function stop_openocd()
  os.execute("pkill openocd")
end

dap.listeners.before.attach.dapui_config = function()
    --start_openocd()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    --start_openocd()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
    --stop_openocd()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
    --stop_openocd()
end



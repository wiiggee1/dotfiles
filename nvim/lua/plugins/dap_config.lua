require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
  })

local dap, dapui = require("dap"), require("dapui")
require('dap').set_log_level('DEBUG')
require('dap').set_log_level('ERROR')
require('dap').set_log_level('TRACE')


dapui.setup()

local function program()
    local path = vim.fn.input({
      prompt = 'Path to executable: ',
      default = vim.fn.getcwd() .. '/',
      completion = 'file'
    })
    print(vim.inspect(path))
    return (path and path ~= "") and path or dap.ABORT
end

-- Check if openocd.gdb exists
local function setup_openocd_gdb_args(adapter)
    local gdb_file = vim.fn.getcwd() .. "/openocd.gdb"
    if vim.fn.filereadable(gdb_file) == 1 then
        table.insert(adapter.args, "-x")
        table.insert(adapter.args, gdb_file)
    end
end


dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  --args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  --args = { "--interpreter=dap", "-q", "-x", "openocd.gdb" }
  args = { "--quiet", "--interpreter=dap", "--eval-command", "set print pretty on" }
}

setup_openocd_gdb_args(dap.adapters.gdb)

dap.adapters["gdb-arm"] = {
  type = "executable",
  command = "arm-none-eabi-gdb",
  --args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
  --args = { "--interpreter=dap", "-q", "-x", "openocd.gdb" }
  args = { "-q", "-i", "dap" }
}

setup_openocd_gdb_args(dap.adapters["gdb-arm"])

if not dap.adapters then dap.adapters = {} end
dap.adapters["probe-rs-debug"] = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
        args = { "dap-server", "--port", "${port}" },
    },
}

dap.configurations.rust = {
    {
        name = "gdb: Launch",
        type = "gdb",
        request = "launch",
        program = program,
        cwd = '${workspaceFolder}',
        target = "localhost:3333",  -- OpenOCD's GDB server port
        runInTerminal = false,
    },
    {
      name = "gdb-arm: Launch",
      type = "gdb-arm",
      request = "launch",
      program = program,
      target = "localhost:3333",
      cwd = '${workspaceFolder}',
      runInTerminal = false,
    },
    {
      name = "gdb-arm: Attach target",
      type = "gdb-arm",
      request = "attach",
      --program = program,
      program = "/home/wiiggee1/Desktop/School/D7020E/lp_2024/d7020e_lab1/target/thumbv7em-none-eabi/debug/examples/rtt_stack",
      target = "localhost:3333",
      cwd = '${workspaceFolder}',
    },
  {
    name = 'gdbserver: attach',
    type = 'gdb',
    request = 'attach',
    program = program,
    target = 'localhost:3333',
    cwd = '${workspaceFolder}',
    --stopAtBeginningOfMainSubprogram = false,
    --stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.rust

--dapui.setup()


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
vim.keymap.set("n", "<Leader>sb", ':lua require"dap".step_back()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dp", ':lua require"dap".pause()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dq", ':lua require"dap".disconnect()<CR>', {noremap=true})

vim.keymap.set("n", "<Leader>dr", ':lua require"dap".repl.toggle()<CR>', {noremap=true})
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end)

--print(vim.inspect(dap.adapters))    
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

dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
end

-- dap.listeners.before.attach.dapui_config = function()
--     --start_openocd()
--     dapui.open()
-- end
-- dap.listeners.before.launch.dapui_config = function()
--     --start_openocd()
--     dapui.open()
-- end

dap.listeners.before.event_terminated.dapui_config = function()
     dapui.close()
--     --stop_openocd()
end
-- dap.listeners.before.event_exited.dapui_config = function()
--     dapui.close()
--     --stop_openocd()
-- end



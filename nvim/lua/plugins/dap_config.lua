--require("dapui").setup()
require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
    
  })

local dap, dapui = require("dap"), require("dapui")

dapui.setup()

dap.adapters.codelldb = {
  type = 'server',
  port = 13000,
  host = "127.0.0.1",
  executable = {
        command = '/home/wiiggee1/.local/share/nvim/mason/packages/codelldb/codelldb',
        args = {"--port", 13000},
    }
}

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

dap.configurations.cpp = {
    {
      -- If you get an "Operation not permitted" error using this, try disabling YAMA:
      --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      name = "Launch file",
      type = 'codelldb',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
      request = 'launch',
      program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    stopOnEntry = false,
    }
}

vim.keymap.set("n", "<Leader>dt", ':lua require("dapui").toggle()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>db", ':lua require"dap".toggle_breakpoint()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dc", ':lua require"dap".continue()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>du", ':lua require"dap".step_over()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>di", ':lua require"dap".step_into()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>do", ':lua require"dap".step_out()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>dr", ':lua require"dap".repl.toggle()<CR>', {noremap=true})
vim.keymap.set("n", "<Leader>do", ':lua require"dap".step_out()<CR>', {noremap=true})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end



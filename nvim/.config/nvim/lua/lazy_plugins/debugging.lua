return {
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        -- recommended = true,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = { virt_text_pos = 'eol' },
            },
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
        },

        keys = {
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            -- { "<leader>dj", function() require("dap").down() end, desc = "Down" },
            -- { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
            { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Widgets" },
            { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },

        config = function ()
            local dap = require("dap")
            local dapui = require("dapui")
            require('mason-nvim-dap').setup({
                ensure_installed = {"cppdbg"},
                automatic_installation = true,
                handlers = {
                    function (config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })
            local proj_root = vim.fn.getcwd()
            dap.set_log_level("error")

            if vim.fn.filereadable(proj_root .. "/openocd.gdb") == 0 then
                vim.notify("openocd.gdb not found at " .. proj_root .. "/openocd.gdb", vim.log.levels.WARN)
            end

            dapui.setup({
                element_mappings = {},
                icons = {
                    collapsed = "",
                    current_frame = "",
                    expanded = ""
                },
                force_buffers = true,
                expand_lines = true,
                controls = {
                    element = "repl",
                    enabled = false,
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
                },
                floating = {
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" }
                    },
                },
                render = {
                    max_type_length = 60,
                    max_value_lines = 100,
                    indent = 1,
                },
                mappings = {
                      edit = "e",
                      expand = { "<CR>", "<2-LeftMouse>" },
                      open = "o",
                      remove = "d",
                      repl = "r",
                      toggle = "t"
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.50 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                        },
                        size = 10,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.7 },
                        },
                        size = 20,
                        position = "bottom",
                    },
                },
            })
            require("nvim-dap-virtual-text").setup()

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            dap.adapters["riscv32-elf-gdb"] = {
                type = "executable",
                command = "riscv32-elf-gdb",
                args = {
                    "--interpreter=dap",
                    -- "--quiet",
                    -- "-x", "openocd.gdb"
                },
                -- args = {"--interpreter=dap", "--eval-command", "set print pretty on", "--quiet" },
            }
            -- Available are: cppdbg, riscv_gdb, gdb, codelldb
            dap.configurations.zig = {
                {
                    name = "gdb: Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = '${workspaceFolder}',
                    -- target = "localhost:3333",  -- OpenOCD's GDB server port
                    stopOnEntry = false,
                    setupCommands = {},
                },
                {
                    name = "riscv-elf-gdb (OpenOCD): Launch",
                    type = "riscv32-elf-gdb",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:3333",
                    miDebuggerPath = "/usr/bin/riscv32-elf-gdb",
                    cwd = '${workspaceFolder}',
                    program = function()
                        return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    -- target = "localhost:3333",  -- OpenOCD's GDB server port
                    stopAtEntry = false,
                    -- postRemoteConnectCommands = {
                    setupCommands = {
                        {
                            text = "file zig-out/bin/edge_ai.elf",
                        },
                        {
                            text = "monitor reset halt",
                        },
                        {
                            text = "maintenance flush register-cache",
                        },
                        {
                            text = function() return "load" end,
                        },
                    }
                },
                {
                    name = "riscv-elf-gdb (OpenOCD): Attach to :3333",
                    type = "riscv32-elf-gdb",
                    request = "attach",
                    -- request = 'launch',
                    target = "localhost:3333",  -- OpenOCD's GDB server port
                    program = function()
                        return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = '${workspaceFolder}',
                    stopAtEntry = false,
                    stopAtBeginningOfMainSubprogram = true,
                    setupCommands = {
                        -- { text = 'set pagination off' },
                        { text = "set print pretty on" },
                        { text = "set print address on" },
                        { text = "set remotetimeout 20" },
                        { text = "set remote hardware-watchpoint-limit 3" },
                        { text = 'monitor reset halt' },
                        { text = 'load' },                 -- flashes/downloads ELF sections
                        { text = 'monitor reset halt' },
                        { text = "maintenance flush register-cache" },
                        { text = 'thbreak app_main' },
                        { text = 'continue' },
                    }
                },
                {
                    name = 'OpenOCD (riscv32) — launch',
                    type = 'cppdbg',
                    request = 'launch',
                    cwd = '${workspaceFolder}',
                    program = function()
				        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			        end,
                    MIMode = 'gdb',
                    miDebuggerPath = '/usr/bin/riscv32-elf-gdb',
                    miDebuggerServerAddress = 'localhost:3333',  -- remote connect
                    stopAtEntry = false,
                    setupCommands = {
                      { text = 'set pagination off' },
                      { text = 'set print pretty on' },
                      { text = 'set remotetimeout 20' },
                      -- { text = 'monitor reset halt' },
                      { text = 'load' },                 -- flashes/downloads ELF sections
                      -- { text = 'monitor reset halt' },
                      { text = 'thbreak app_main' },
                      -- { text = 'monitor gdb_breakpoint_override hard' }, -- optional (flash bp)
                      -- { text = 'info files' },           -- optional sanity check
                    },
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
                    name = 'gdbserver: attach',
                    type = 'gdb',
                    request = 'attach',
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    target = 'localhost:3333',
                    cwd = '${workspaceFolder}',
                },
            }
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- vim.keymap.set("n", "<space>?", function ()
            --    dapui.eval(nil, { enter = true })
            -- end)

        end
    },

}


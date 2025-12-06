
-- Editor shortcuts, useful for programming and software development
-- vim.api.nvim_set_keymap('n','lhs', 'rhs', option)
local keybind = vim.keymap.set
local default_options = { noremap = true, silent = true }

local diagnostic = vim.diagnostic
--local test = vim.api.
-- CR = "Enter key"

-- Set leader key
vim.g.mapleader=" "
keybind("n", "<leader>pv", vim.cmd.Ex)

-- Shortcut keybinding for saving file using: "CTRL S"
keybind("i", "<C-s>", "<Esc>:w<CR>:echo 'File saved!'<CR>i")

-- Keybinding for undo using: "CTRL Z"
keybind("i", "<C-z>", "<Esc>:undo<CR>i")

-- Keybinding for deleting line in "insert mode"
keybind("i", "<C-x>", "<Esc>dd<CR>i")

-- Keybinding for copy line in "insert mode"
keybind("i", "<C-c>", "<Esc><S-y><CR>i")

-- Keybinding for pasting in "insert mode"

keybind("i", "<C-v>", "<Esc>p<CR>i")

-- Keybinding for "write and quit" in insert mode:
keybind("i", "<C-q>", "<Esc>:wq<CR>")

-- Keybinding for displaying file explorer thru "Nvimtree plugin"
keybind("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Keybinding for displaying terminal window
-- keybind("n", "<leader>tt", ":ToggleTerm<CR>")
keybind("t", "<C-t>", ("exit<CR>"))

-- Bindings for jumping between "next" and "previous" buffers instead of tabs
keybind("n", "<leader>gn", ":bnext<CR>")
keybind("n", "<leader>gb", ":bprevious<CR>")
keybind("n", "<leader>bf", ":bfirst<CR>")
keybind("n", "<leader>bl", ":blast<CR>")

-- Window Pane Navigation: 
-- <C-w>h = Left window
-- <C-w>l = Right window
-- <C-w>k = Up window
-- <C-w>j = Down window
-- ##################################
-- <C-w>r = Move window to Right side
-- <C-w>l = Move window to Left side 
-- ##################################

keybind("n", "<leader>sv", ":vsplit<CR>") -- Vertical window split. 
keybind("n", "<leader>sh", ":split<CR>") -- Horizontal split.
-- keybind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)

-- Diagnostic keybinding: 
keybind("n", "<leader>d", diagnostic.open_float)
keybind("n", "<leader>dj", function ()
    diagnostic.jump({count = 1, float = true})
end)
keybind("n", "<leader>dk", function ()
    diagnostic.jump({count = -1, float = true})
end)

-- Markdown keybindings: 
keybind("n", "<leader>mp", ":MarkdownPreviewToggle<CR>")

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
    local opts = {buffer = event.buf}

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

    keybind('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    keybind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    keybind('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    keybind('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    keybind('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    keybind('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    keybind('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    keybind('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    keybind('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end
})

-- Keymap for preview definition in floating window instead of switching buffer window. 
keybind("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})

-- Keymaps for neotest, mainly for running test blocks directly in the 
-- neovim UI. 

keybind("n", "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<cr>") -- Toggle/Opening the testing summary window.  
keybind("n", "<leader>to", "<cmd>lua require('neotest').output.open()<cr>") -- For showing the test output.  
keybind("n", "<leader>tr", "<cmd>lua require'neotest'.run.run()<cr>")
keybind("n", "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>")
keybind("n", "<leader>ts", "<cmd>lua require('neotest').run.stop()<cr>")
keybind("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>")
keybind("n", "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>")


-- vim.keymap.set("n", "<localleader>ip", function()
--   local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
--   if venv ~= nil then
--     -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
--     venv = string.match(venv, "/.+/(.+)")
--     vim.cmd(("MoltenInit %s"):format(venv))
--   else
--     vim.cmd("MoltenInit python3")
--   end
-- end, { desc = "Initialize Molten for python3", silent = true })


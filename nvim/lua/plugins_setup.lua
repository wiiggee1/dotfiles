--vim.cmd [[packadd packer.nvim]]

-- Bootstrapping for automatically install and setup 'packer.nvim'
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if (not status) then
    return
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              height = 10, 
              icons = false,
              mode = "workspace_diagnostics",
              padding = true, -- add an extra new line on top of the list
              cycle_results = true, 
              auto_preview = true,
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
              fold_open = "v", -- icon used for open folds
              fold_closed = ">", -- icon used for closed folds
            indent_lines = true, -- add an indent guide below the fold icons
            signs = {
        -- icons / text used for a diagnostic
                error = "error",
                warning = "warn",
                hint = "hint",
                information = "info"
            },
            auto_open = false,  -- Automatically open the trouble list on error
            auto_close = false, -- Automatically close the trouble list when it's empty
            use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
          }
      end
    })

  -- My plugins here
    use {"catppuccin/nvim", as = "catppuccin"}
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-jdtls'
    use 'mfussenegger/nvim-lint'
    use 'jay-babu/mason-nvim-dap.nvim'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
    --use 'theHamsta/nvim-dap-virtual-text'

    -- Markdown plugin. 
    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })

    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
    -- use({
    --     "iamcco/markdown-preview.nvim",
    --     run = function() vim.fn["mkdp#util#install"]() end,
    -- })


    -- LaTeX syntax plugin
    -- use({
    --     'lervag/vimtex',
    --     init = function()
    --         -- VimTeX configuration goes here, e.g.
    --             vim.g.vimtex_view_method = "zathura"
    --             vim.g.vimtex_view_general_viewer = 'okular'
    --             vim.g.vimtex_indent_enabled = false
    --             vim.g.tex_indent_items = false
    --             vim.g.tex_indent_brace = false
    --             vim.g.tex_flavor = 'latex'
    --             vim.g.vimtex_mappings_enabled = false
    --     end,
    -- })

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {'windwp/nvim-autopairs',
        config = function () require("nvim-autopairs").setup {} end
    }
    use 'windwp/nvim-ts-autotag'

    use {"akinsho/toggleterm.nvim",
        tag = '*',
        config = function() require("toggleterm").setup({
            shade_terminals = true
        }) end
    }
    -- use('akinsho/toggleterm.nvim')
    use('akinsho/nvim-bufferline.lua')
    use('nvim-lualine/lualine.nvim')
    use('kyazdani42/nvim-web-devicons')
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {'nvim-tree/nvim-web-devicons'}
    }
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    })

    use {'j-hui/fidget.nvim', tag = 'v1.5.0'}
    --use 'simrat39/rust-tools.nvim'
    use 'onsails/lspkind.nvim' -- vs-code like icons for autocompletion
    use ({'folke/neodev.nvim',})
    use({
        'folke/todo-comments.nvim',
        requires = {"nvim-lua/plenary.nvim"}
    })

    use {
	    'VonHeikemen/lsp-zero.nvim',
	    branch = 'v4.x',
	    requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {
              'williamboman/mason.nvim', 
              run = function()
                  pcall(vim.cmd, 'MasonUpdate')
              end, 
          },
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  --{'rafamadriz/friendly-snippets'},
	    }
  }
  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end

end)



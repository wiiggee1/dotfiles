return {
	"nvim-neotest/neotest",
	dependencies = {
        "nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"lawrence-laz/neotest-zig", -- Installation
	},
	config = function()

		require("neotest").setup({
			adapters = {
				-- Registration
				require("neotest-zig")({
					-- dap = {
					-- 	adapter = "lldb",
					-- }
				}),
			}
		})
	end
}

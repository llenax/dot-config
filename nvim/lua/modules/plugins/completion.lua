return {
	{
		"saghen/blink.cmp",
		-- "hrsh7th/nvim-cmp",
		lazy = false,
		priority = 100,
		dependencies = {
			"onsails/lspkind.nvim",
			{
				"fang2hou/blink-copilot",
				opts = {
					max_completions = 1, -- Global default for max completions
					max_attempts = 2, -- Global default for max attempts
				},
			},
			-- "hrsh7th/cmp-nvim-lsp",
			-- "hrsh7th/cmp-path",
			-- "hrsh7th/cmp-buffer",
			-- { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			-- "saadparwaiz1/cmp_luasnip",
			-- "roobert/tailwindcss-colorizer-cmp.nvim",
		},
		version = "1.*",
		config = function()
			require("modules.configs.completion")
		end,
	},
}

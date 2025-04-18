return {
	{
		"jesseleite/nvim-noirbuddy",
		dependencies = {
			{ "tjdevries/colorbuddy.nvim" },
		},
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("noirbuddy").setup({
				preset = "miami-nights",
			})
		end,
	},
}

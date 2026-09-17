return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.nvim",
	},
	---@module "render-markdown"
	---@type render.md.UserConfig
	opts = {},
	keys = {
		{
			"<leader>m",
			function()
				require("render-markdown").toggle()
			end,
			desc = "Toggle markdown rendering",
		},
	},
}

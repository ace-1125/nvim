return {
	"brenoprata10/nvim-highlight-colors",
	event = "BufReadPre",
	opts = {
		render = "virtual",
		virtual_symbol = "■■■■",
	},
	keys = {
		{
			"<leader>pc",
			function()
				require("nvim-highlight-colors").toggle()
			end,
			desc = "Toggle highlight colors",
		},
	},
}

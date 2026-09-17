return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 300,
		icons = {
			mappings = vim.g.have_nerd_font,
		},
		spec = {
			{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Register group labels for leader prefixes
		wk.add({
			{ "<leader>r", group = "Replace" },
			{ "<leader>u", group = "Toggle" },
			{ "<leader>w", group = "Window" },
			{ "<leader>n", group = "Neotest" },
		})
	end,
}

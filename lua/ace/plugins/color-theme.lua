return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "moon",
		on_highlights = function(hl, c)
			hl.Normal = { bg = "NONE" }
			hl.NormalNC = { bg = "NONE" }
			hl.SpellBad = { sp = c.red, undercurl = true }
			hl.NormalSolid = { bg = c.bg_dark, fg = c.fg }

			-- gutter
			hl.SignColumn = { bg = c.bg_dark }
			hl.LineNr = { bg = c.bg_dark }
			hl.CursorLineNr = { bg = c.bg_dark }
			hl.LineNrAbove = { bg = c.bg_dark }
			hl.LineNrBelow = { bg = c.bg_dark }

			-- cmdline / messages area (this is the “command bar” vibe)
			hl.MsgArea = { bg = c.bg_dark }
			hl.MsgSeparator = { bg = c.bg_dark }
			hl.Cmdline = { bg = c.bg_dark }
			hl.CmdlinePrompt = { bg = c.bg_dark }
			hl.TerminalNormal = { bg = "#0C0D14" }

			-- imports modification
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					vim.api.nvim_set_hl(0, "@keyword.import", { link = "Keyword" })
					vim.api.nvim_set_hl(0, "@module", { link = "Identifier" })
				end,
			})

			-- Custom autosave colors
			hl.AutoSaveOn = { fg = c.green2 }
			hl.AutoSaveIgnored = { fg = c.warning }
			hl.AutoSaveOff = { fg = c.blue }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}

return {
	"nvim-mini/mini.nvim",
	lazy = false,
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		local default_section_filename = statusline.section_filename

		local function save_icon()
			local state = _G.autosave_state()
			if state == "on" then
				return "%#AutoSaveOn# ●%*"
			elseif state == "ignored" then
				return "%#AutoSaveIgnored# ●%*"
			else
				return "%#AutoSaveOff# ●%*"
			end
		end

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v " .. save_icon()
		end

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_filename = function(args)
			return default_section_filename(args)
		end

		require("mini.pairs").setup()
	end,
}

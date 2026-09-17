return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({
					action = "focus",
					source = "filesystem",
					toggle = true,
					dir = vim.fn.getcwd(),
					reveal = true,
				})
			end,
			desc = "Explorer (Neo-tree)",
		},
		--{ '<leader>rr', '<cmd>Neotree reveal<cr>', desc = 'Reveal file in Neo-tree' },
		{ "<leader>be", "<cmd>Neotree buffers toggle<cr>", desc = "Buffers (Neo-tree)" },
	},
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",

		filesystem = {
			follow_current_file = { enabled = true }, -- keeps tree in sync when you navigate normally
			use_libuv_file_watcher = true,
			hijack_netrw_behavior = "open_default",
		},

		window = {
			width = 32,
			mappings = {
				["<leader>e"] = "noop",
				["l"] = "open",
				["h"] = "close_node",
				["S"] = "open_split",
				["V"] = "open_vsplit",
				["T"] = "open_tabnew",
				["R"] = "refresh",
				["q"] = "close_window",

				-- file ops
				["a"] = "add",
				["d"] = "delete",
				["r"] = "rename",
				["c"] = "copy",
				["m"] = "move",

				-- handy
				["Y"] = "copy_to_clipboard", -- copies path
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)

		-- Auto-reveal after Telescope jumps (only if Neo-tree is already open)
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				-- only for real files
				local name = vim.api.nvim_buf_get_name(0)
				if name == "" then
					return
				end
				if vim.bo.buftype ~= "" then
					return
				end

				local ok_cmd, cmd = pcall(require, "neo-tree.command")
				local ok_mgr, mgr = pcall(require, "neo-tree.sources.manager")
				local ok_utils, utils = pcall(require, "neo-tree.utils")
				if not (ok_cmd and ok_mgr) then
					return
				end
				if not ok_utils then
					return
				end

				local state = mgr.get_state("filesystem")
				if not state or not state.winid or not vim.api.nvim_win_is_valid(state.winid) then
					return -- Neo-tree not open; don't auto-open it
				end

				local root = state.path or mgr.get_cwd(state)
				if not utils.is_subpath(root, name) then
					return
				end

				cmd.execute({
					action = "reveal",
					source = "filesystem",
					reveal_force_cwd = false,
				})
			end,
		})
	end,
}

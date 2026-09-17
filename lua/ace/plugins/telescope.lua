return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		"debugloop/telescope-undo.nvim",
	},
	config = function()
		require("telescope").setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob",
					"!.git/",
				},
				layout_config = {
					width = 0.99,
					height = 0.98,
					horizontal = { preview_width = 0.6 },
					vertical = { preview_height = 0.5 },
				},
			},
			pickers = {
				find_files = { hidden = false, no_ignore = false },
			},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
				undo = {},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "undo")

		local builtin = require("telescope.builtin")

		-- Search
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
		vim.keymap.set("n", "<leader>ss", builtin.git_files, { desc = "Search git files" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by grep" })
		vim.keymap.set("n", "<leader>sG", function()
			builtin.grep_string({ search = vim.fn.input("Grep ❯ ") })
		end, { desc = "Grep (input)" })
		vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "Search current word" })
		vim.keymap.set("n", "<leader>se", function()
			builtin.find_files({ hidden = true, no_ignore = true, prompt_title = "Find Files (Everything)" })
		end, { desc = "Search everything" })
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, { desc = "Search in open files" })

		-- Navigation
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find buffers" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search resume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "Search recent files" })
		vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "Undo tree" })

		-- Misc
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
		vim.keymap.set("n", "<leader>sb", builtin.builtin, { desc = "Search telescope builtins" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search commands" })
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search neovim files" })

		-- Buffer fuzzy find
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "Fuzzy search in buffer" })

		-- LSP keymaps (only when attached)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf
				vim.keymap.set("n", "<leader>grr", builtin.lsp_references, { buffer = buf, desc = "Goto references" })
				vim.keymap.set(
					"n",
					"<leader>gri",
					builtin.lsp_implementations,
					{ buffer = buf, desc = "Goto implementation" }
				)
				vim.keymap.set("n", "<leader>grd", builtin.lsp_definitions, { buffer = buf, desc = "Goto definition" })
				vim.keymap.set(
					"n",
					"<leader>grt",
					builtin.lsp_type_definitions,
					{ buffer = buf, desc = "Goto type definition" }
				)
				vim.keymap.set(
					"n",
					"<leader>gO",
					builtin.lsp_document_symbols,
					{ buffer = buf, desc = "Document symbols" }
				)
				vim.keymap.set(
					"n",
					"<leader>gW",
					builtin.lsp_dynamic_workspace_symbols,
					{ buffer = buf, desc = "Workspace symbols" }
				)
			end,
		})
	end,
}

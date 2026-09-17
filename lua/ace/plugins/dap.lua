return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		{ "mfussenegger/nvim-dap-python" },
		{ "williamboman/mason.nvim" },
		{ "jay-babu/mason-nvim-dap.nvim" },
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "DAP: Continue",
		},
		{
			"<F6>",
			function()
				require("dap").step_over()
			end,
			desc = "DAP: Step over",
		},
		{
			"<F8>",
			function()
				require("dap").step_into()
			end,
			desc = "DAP: Step into",
		},
		{
			"<S-F11>",
			function()
				require("dap").step_out()
			end,
			desc = "DAP: Step out",
		},
		{
			"<F10>",
			function()
				require("dap").terminate()
			end,
			desc = "DAP: Terminate",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "DAP: Toggle breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "DAP: Clear breakpoints",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "DAP: Toggle UI",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "DAP: Run last",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Mason installs debugpy
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			ensure_installed = { "python" },
		})

		-- UI
		dapui.setup()
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Colors
		local dap_hl = "Normal:NormalSolid,SignColumn:NormalSolid,EndOfBuffer:NormalSolid"

		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function()
				local ft = vim.bo.filetype
				if ft:match("^dapui_") or ft == "dap-repl" then
					vim.wo.winhighlight = dap_hl
				end
			end,
		})

		dap.listeners.after.event_initialized["dapui_bg"] = function()
			vim.schedule(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
					if ft:match("^dapui_") or ft == "dap-repl" then
						vim.wo[win].winhighlight = dap_hl
					end
				end
			end)
		end

		-- Signs
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })

		-- Python — uses mason's debugpy, resolves .venv for the program
		local mason_path = vim.fn.stdpath("data") .. "/mason"
		require("dap-python").setup(mason_path .. "/packages/debugpy/venv/bin/python")
		require("dap-python").test_runner = "pytest"

		-- Auto-find .venv in workspace root
		local function get_python_path()
			local venv = vim.fn.getcwd() .. "/.venv/bin/python"
			if vim.fn.executable(venv) == 1 then
				return venv
			end
			return "python3"
		end

		-- Override default configs to use .venv
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = get_python_path,
				console = "integratedTerminal",
			},
			{
				type = "python",
				request = "launch",
				name = "Launch file (with args)",
				program = "${file}",
				pythonPath = get_python_path,
				console = "integratedTerminal",
				args = function()
					local input = vim.fn.input("Args: ")
					return input ~= "" and vim.fn.split(input, " ") or {}
				end,
			},
			{
				type = "python",
				request = "launch",
				name = "Launch file (custom interpreter)",
				program = "${file}",
				console = "integratedTerminal",
				pythonPath = function()
					return vim.fn.input("Python path: ", vim.fn.getcwd() .. "/.venv/bin/python", "file")
				end,
			},
		}
	end,
}

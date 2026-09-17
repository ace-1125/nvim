return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
	},
	keys = {
		{ "<leader>nt", function() require("neotest").run.run() end,                                                  desc = "Run nearest test" },
		{ "<leader>nf", function() require("neotest").run.run(vim.fn.expand "%") end,                                 desc = "Run test file" },
		{ "<leader>no", function() require("neotest").output.open { enter = true, auto_close = true } end,            desc = "Open test output" },
		{ "<leader>ns", function() require("neotest").summary.toggle() end,                                           desc = "Toggle test summary" },
		{ "<leader>nl", function() require("neotest").run.run_last() end,                                             desc = "Run last test" },
	},
  config = function()
	local lib = require("neotest.lib")

	local function find_monorepo_root(path)
		-- Vitest workspace file
		local ws_root = lib.files.match_root_pattern(
			"vitest.workspace.ts",
			"vitest.workspace.js",
			"vitest.workspace.mts",
			"vitest.workspace.mjs"
		)(path)
		if ws_root then
			return ws_root
		end

		-- Walk up for package.json "workspaces" or pnpm-workspace.yaml
		local dir = vim.fn.fnamemodify(path, ":p:h")
		while dir and dir ~= "/" do
			local ok, content = pcall(lib.files.read, dir .. "/package.json")
			if ok then
				local parsed = vim.json.decode(content)
				if parsed and parsed.workspaces then
					return dir
				end
			end
			if vim.uv.fs_stat(dir .. "/pnpm-workspace.yaml") then
				return dir
			end
			dir = vim.fn.fnamemodify(dir, ":h")
		end

		-- Fallback: git root
		local git_root = vim.fn.systemlist(
			"git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(path, ":h")) .. " rev-parse --show-toplevel"
		)[1]
		if vim.v.shell_error == 0 and git_root and git_root ~= "" then
			return git_root
		end
		return nil
	end

	require("neotest").setup({
		adapters = {
			require("neotest-vitest")({
				cwd = function(path)
					local config_root = lib.files.match_root_pattern(
						"vitest.config.ts",
						"vitest.config.js",
						"vitest.config.mts",
						"vitest.config.mjs",
						"vite.config.ts",
						"vite.config.js"
					)(path)
					return config_root or find_monorepo_root(path) or vim.uv.cwd()
				end,
				filter_dir = function(name)
					return name ~= "node_modules"
						and name ~= ".git"
						and name ~= "dist"
						and name ~= "build"
						and name ~= "coverage"
						and name ~= ".nx"
						and name ~= "cdk.out"
				end,
			}),
		},
		discovery = { enabled = true },
		status = { enabled = true, signs = false, virtual_text = true },
		diagnostic = { enabled = true },
	})

	-- Clean up diagnostic virtual text
	vim.diagnostic.config({
		virtual_text = {
			format = function(d)
				return d.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			end,
		},
	}, vim.api.nvim_create_namespace("neotest"))
  end,
}


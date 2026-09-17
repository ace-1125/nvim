return {
	{ "mason-org/mason.nvim", opts = {} },
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = { ensure_installed = { "stylua", "prettier", "pyright" } },
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile", "BufReadPre" },
		lazy = false,
		dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
		config = function()
			-- Keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("grn", vim.lsp.buf.rename, "Rename")
					map("gra", vim.lsp.buf.code_action, "Code Action")
					map("grD", vim.lsp.buf.declaration, "Goto Declaration")
					-- add yours here
					map("H", vim.lsp.buf.hover, "[H]over over cursor")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "pyright" then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			-- Server configs
			local servers = {
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
								path = { "lua/?.lua", "lua/?/init.lua" },
							},
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
						})
					end,
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								diagnosticSeverityOverrides = {
									reportUnusedVariable = "none",
									reportUnusedImport = "none",
								},
							},
						},
					},
				},
				ts_ls = {},
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			for name, cfg in pairs(servers) do
				cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
				vim.lsp.config(name, cfg)
				vim.lsp.enable(name)
			end
		end,
	},
}

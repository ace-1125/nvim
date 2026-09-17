local group = vim.api.nvim_create_augroup("autosave", { clear = true })

vim.g.autosave_enabled = true

local ignore_paths = {
	vim.fn.stdpath("config"),
	vim.fs.normalize(vim.fn.expand("~/.config")),
}

local function is_ignored(filepath)
	if not filepath or filepath == "" then
		return true
	end
	filepath = vim.fs.normalize(filepath)

	for _, path in ipairs(ignore_paths) do
		path = vim.fs.normalize(path)
		if filepath == path or filepath:find(path .. "/", 1, true) == 1 then
			return true
		end
	end
	return false
end

local function can_save()
  if not vim.g.autosave_enabled then return false end
  if is_ignored(vim.fn.expand '%:p') then return false end
  if vim.bo.filetype == 'gitcommit' then return false end
  if vim.bo.buftype ~= '' then return false end
  if not vim.bo.modifiable then return false end
  return true
end

vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
	group = group,
	callback = function()
		if can_save() and vim.bo.modified then
			---@diagnostic disable-next-line: param-type-mismatch
			pcall(vim.cmd, "silent write")
		end
	end,
})

vim.keymap.set("n", "<leader>ua", function()
	vim.g.autosave_enabled = not vim.g.autosave_enabled
	vim.cmd("redrawstatus")

	local msg = "OFF"
	if vim.g.autosave_enabled and can_save() then
		msg = "ON"
	elseif vim.g.autosave_enabled then
		msg = "OFF (BUFFER)"
	end
	print("Autosave: " .. msg)
end, { desc = "Toggle autosave" })

---@diagnostic disable-next-line: duplicate-set-field
function _G.autosave_state()
	if not vim.g.autosave_enabled then
		return "off"
	end
	if can_save() then
		return "on"
	end
	return "ignored"
end

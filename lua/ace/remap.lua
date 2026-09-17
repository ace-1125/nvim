-- Core keymaps (no plugin dependencies)
local term_buf = nil
local term_win = nil

local function toggle_terminal()
	-- If window exists → close it
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end

	-- Open bottom split
	vim.cmd("botright split")
	vim.cmd("resize 12")

	term_win = vim.api.nvim_get_current_win()

	-- If buffer exists → reuse it
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_win_set_buf(term_win, term_buf)
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
	end

	vim.cmd("startinsert")
end

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.wo.winhighlight = "Normal:TerminalNormal"
	end,
})

vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle terminal (bottom)' })

-- exit terminal mode easily
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- NOTE: Terminal end ##########################################################################

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>v', '<C-v>', { desc = 'Visual block' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- NOTE: window mgnt start #####################################################################
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>wh', ':vertical resize -5<CR>')
vim.keymap.set('n', '<leader>wl', ':vertical resize +5<CR>')
vim.keymap.set('n', '<leader>wj', ':resize -5<CR>')
vim.keymap.set('n', '<leader>wk', ':resize +5<CR>')

vim.keymap.set('n', '<leader>wK', function() vim.cmd 'wincmd _' end, { desc = 'maximize vertical' })
vim.keymap.set('n', '<leader>wL', function() vim.cmd 'wincmd |' end, { desc = 'maximize horizontal' })

vim.keymap.set('n', '<leader>uw', function() vim.wo.wrap = not vim.wo.wrap end, { desc = 'Toggle wrap' })

-- NOTE: window mgnt end #####################################################################
vim.keymap.set('n', '<leader>us', function() vim.o.spell = not vim.o.spell end, { desc = 'Toggle spell' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', '<leader>rf', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'replace word in file' })
vim.keymap.set('v', '<leader>rv', ':s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'replace word in selection' })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'make file executable' })

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
	lazy = false,

  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local list = harpoon:list()

    -- add file
    vim.keymap.set('n', '<leader>a', function() list:add() end, { desc = 'Harpoon: Add file' })

    -- toggle menu
    vim.keymap.set('n', '<leader>j', function() harpoon.ui:toggle_quick_menu(list) end, { desc = 'Harpoon: Menu' })

    -- jump by index
    vim.keymap.set('n', '<leader>1', function() list:select(1) end, { desc = 'Harpoon: (file 1-9)' })
    vim.keymap.set('n', '<leader>2', function() list:select(2) end)
    vim.keymap.set('n', '<leader>3', function() list:select(3) end)
    vim.keymap.set('n', '<leader>4', function() list:select(4) end)
    vim.keymap.set('n', '<leader>5', function() list:select(5) end)
    vim.keymap.set('n', '<leader>6', function() list:select(6) end)
    vim.keymap.set('n', '<leader>7', function() list:select(7) end)
    vim.keymap.set('n', '<leader>8', function() list:select(8) end)
    vim.keymap.set('n', '<leader>9', function() list:select(9) end)

    -- jump by index
    vim.keymap.set('n', '<C-1>', function() list:select(1) end, { desc = 'Harpoon: (file 1-9)' })
    vim.keymap.set('n', '<C-2>', function() list:select(2) end)
    vim.keymap.set('n', '<C-3>', function() list:select(3) end)
    vim.keymap.set('n', '<C-4>', function() list:select(4) end)
    vim.keymap.set('n', '<C-5>', function() list:select(5) end)
    vim.keymap.set('n', '<C-6>', function() list:select(6) end)
    vim.keymap.set('n', '<C-7>', function() list:select(7) end)
    vim.keymap.set('n', '<C-8>', function() list:select(8) end)
    vim.keymap.set('n', '<C-9>', function() list:select(9) end)

    require('which-key').add {
      { '<leader>2', hidden = true },
      { '<leader>3', hidden = true },
      { '<leader>4', hidden = true },
      { '<leader>5', hidden = true },
      { '<leader>6', hidden = true },
      { '<leader>7', hidden = true },
      { '<leader>8', hidden = true },
      { '<leader>9', hidden = true },
    }

    -- move prev/next index
    vim.keymap.set('n', '<leader>h', function() list:prev() end, { desc = 'Harpoon prev' })
    vim.keymap.set('n', '<leader>l', function() list:next() end, { desc = 'Harpoon next' })
  end,
}


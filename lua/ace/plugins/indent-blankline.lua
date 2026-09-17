return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help ibl`
    main = 'ibl',
    opts = { enabled = false },
    config = function(_, opts)
      local ibl = require 'ibl'
      ibl.setup(opts)

      local enabled = opts.enabled ~= false

      vim.keymap.set('n', '<leader>ii', function()
        enabled = not enabled
        ibl.update { enabled = enabled }
      end, { desc = 'Toggle indent guides' })
    end,
  },
}


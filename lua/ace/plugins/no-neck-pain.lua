return {
  'shortcuts/no-neck-pain.nvim',
  keys = {
    { '<leader>uz', '<cmd>NoNeckPain<cr>', desc = 'Toggle zen mode' },
  },
  opts = {
    width = 120,
    buffers = {
      right = { enabled = true },
      left = { enabled = true },
      bo = {
        modifiable = false,
        readonly = true,
        buflisted = false,
        buftype = 'nofile',
        filetype = 'no-neck-pain',
      },
      wo = {
        number = false,
        relativenumber = false,
        signcolumn = 'no',
        foldcolumn = '0',
        cursorline = false,
        fillchars = 'eob: ',
      },
    },
  },
}


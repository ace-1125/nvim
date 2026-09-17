return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable = true,
    max_lines = 3,
    trim_scope = 'outer',
    mode = 'cursor',
  },
  config = function(_, opts) require('treesitter-context').setup(opts) end,
  keys = {
    {
      '[c',
      function() require('treesitter-context').go_to_context() end,
      desc = 'Jump to context',
    },
    {
      '<leader>uc',
      function() require('treesitter-context').toggle() end,
      desc = 'Toggle Treesitter context',
    },
  },
}


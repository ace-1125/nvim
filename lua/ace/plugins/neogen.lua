return {
  'danymat/neogen',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    { '<leader>d', function() require('neogen').generate() end, desc = 'Generate docstring' },
  },
  opts = {
    -- no snippet_engine needed for neogen v2 — uses native vim.snippet
    languages = {
      python = { template = { annotation_convention = 'google_docstrings' } },
      typescript = { template = { annotation_convention = 'tsdoc' } },
      lua = { template = { annotation_convention = 'emmylua' } },
    },
  },
}


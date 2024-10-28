return  { 'https://github.com/romgrk/barbar.nvim',
    dependencies = {
      'https://github.com/lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'https://github.com/nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    keys = {
      { '[b', '<Cmd>BufferPrevious<CR>', desc = 'Previous buffer in bar list', mode = 'n', silent = true },
      { ']b', '<Cmd>BufferNext<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
      { '[B', '<Cmd>BufferMovePrevious<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
      { ']B', '<Cmd>BufferMoveNext<CR>', desc = 'Next buffer in bar list', mode = 'n', silent = true },
    },
    opts = {
      hide = { extensions = true },
      sidebar_filetypes = {
        NvimTree = true,
        undotree = {text = 'undotree'},
        ['neo-tree'] = {event = 'BufWipeout'},
      },
    },
  }

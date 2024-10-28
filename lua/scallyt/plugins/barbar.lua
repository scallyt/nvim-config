return {
  'https://github.com/romgrk/barbar.nvim',
  dependencies = {
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
  },
  init = function() vim.g.barbar_auto_setup = false end,
  config = function()
    require('barbar').setup {
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = true },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = {
          custom_colors = false,

          enabled = true,
        },
        separator = { left = '▎', right = '' },

        separator_at_end = true,

        modified = { button = '●' },
        pinned = { button = '', filename = true },

        preset = 'default',

        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },

      maximum_length = 30,

      hide = { extensions = true },
      sidebar_filetypes = {
        NvimTree = true,
        undotree = { text = 'undotree' },
        ['neo-tree'] = { event = 'BufWipeout' },
        clickable = true,
        Outline = {event = 'BufWinLeave', text = 'symbols-outline', align = 'right'},
      },
    }

    -- Keymaps with friendly names for which-key
    local mappings = {
      b = {
        name = "Buffers",
        p = { "<Cmd>BufferPrevious<CR>", "Previous Buffer" },
        n = { "<Cmd>BufferNext<CR>", "Next Buffer" },
        m = {
          name = "Move",
          p = { "<Cmd>BufferMovePrevious<CR>", "Move Buffer Left" },
          n = { "<Cmd>BufferMoveNext<CR>", "Move Buffer Right" },
        },
        c = { "<Cmd>BufferClose<CR>", "Close Buffer" },
        C = { "<Cmd>BufferCloseAllButCurrent<CR>", "Close All But Current" },
      },
    }

    require("which-key").register(mappings, { prefix = "<leader>" })
  end,
  event = 'BufWinEnter',
}

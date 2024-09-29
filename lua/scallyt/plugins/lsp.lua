return {
  "neovim/nvim-lspconfig",
  dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
  },

  config = function()
      local lsp_zero = require('lsp-zero')
      local cmp = require('cmp')
      local lspconfig = require('lspconfig')
      
      -- Configure nvim-cmp
      cmp.setup({
          snippet = {
              expand = function(args)
                  require('luasnip').lsp_expand(args.body) -- LuaSnip használata
              end,
          },
          mapping = {
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Kódkitöltés megerősítése
              ['<Tab>'] = cmp.mapping.select_next_item(),
              ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          },
          sources = {
              { name = 'nvim_lsp' }, -- LSP forrás
              { name = 'luasnip' },  -- Snippet forrás
              { name = 'buffer' },   -- Buffer forrás
          },
      })

      -- Define a function for attaching the LSP to buffers
      local lsp_attach = function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr })
      end

      -- Initialize and configure mason for LSP management
      require('mason').setup({})
      require('mason-lspconfig').setup({
          ensure_installed = {
              'gopls',        -- Go
              'lua_ls',       -- Lua
              'eslint',       -- JavaScript/TypeScript linter
              'emmet-language-server',
              'htmx-lsp',
              'tailwindcss-language-server',
          },
          automatic_installation = true,
      })

      -- Configure gopls, lua-lsp, and eslint with lsp-zero
      lspconfig.gopls.setup({
          on_attach = lsp_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Használj default_capabilities-t
      })

      lspconfig.lua_ls.setup({
          on_attach = lsp_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          settings = {
              Lua = {
                  diagnostics = {
                      globals = { 'vim' },  -- Recognize 'vim' as a global
                  },
                  workspace = {
                      library = vim.api.nvim_get_runtime_file("", true),  -- Make LSP aware of Neovim runtime
                  },
              },
          },
      })

      lspconfig.eslint.setup({
          on_attach = lsp_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          settings = {
              validate = "onSave",
          },
      })

      lspconfig.emmet_language_server.setup({
          filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
          init_options = {
              showAbbreviationSuggestions = true,
              showExpandedAbbreviation = "always",
          },
      })

      lspconfig.tailwindcss.setup({
          filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" }
      })

      lspconfig.htmx.setup({})
  end
}

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
  capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Használj default_capabilities-t
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
  capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Használj default_capabilities-t
  settings = {
    validate = "onSave",
  },
})

lspconfig.emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})
lspconfig.tailwindcss.setup({
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" }
})
lspconfig.htmx.setup{}

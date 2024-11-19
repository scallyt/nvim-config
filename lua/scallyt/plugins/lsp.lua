return {
    {
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
            "mfussenegger/nvim-dap",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-jdtls",
        },
        config = function()
            -- Core LSP setup
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local cmp = require("cmp")

            -- Mason setup
            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                    "eslint",
                    "emmet_language_server",
                    "tailwindcss",
                    "clangd",
                    "ts_ls",
                },
                automatic_installation = true,
            })

            -- CMP setup
            cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    }),
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            side_padding = 1,
            max_item_count = 8, -- maximum 8 ajánlás jelenik meg
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
            side_padding = 1,
        }),
    },
})


            -- Helper function for LSP attach
            local on_attach = function(_, bufnr)
                -- Default LSP keymaps
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode Hover" })
                vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Definition" })
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode References" })
                vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Implementations" })
                vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode Rename" })
                vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Declaration" })
            end

            -- LSP setup helper
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local function setup_lsp(server, opts)
                lspconfig[server].setup(vim.tbl_extend("force", {
                    on_attach = on_attach,
                    capabilities = capabilities,
                }, opts or {}))
            end

            -- Language server configurations
            setup_lsp("gopls")
            setup_lsp("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })
            setup_lsp("ts_ls")
            setup_lsp("eslint", { settings = { validate = "onSave" } })
            setup_lsp("clangd", {
                on_attach = function(client, bufnr)
                    client.server_capabilities.signatureHelpProvider = false
                    on_attach(client, bufnr)
                end,
            })
            setup_lsp("emmet_language_server", {
                filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
                init_options = { showAbbreviationSuggestions = true, showExpandedAbbreviation = "always" },
            })
            setup_lsp("tailwindcss", {
                filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
            })

            -- Debugger setup with mason-nvim-dap
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test" },
            })
        end,
    },
}

-- ChatGpt fix


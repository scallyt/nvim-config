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
        },

        config = function()
            local lsp_zero = require("lsp-zero")
            local cmp = require("cmp")
            local lspconfig = require("lspconfig")

            -- Set up nvim-cmp
            cmp.setup({
                    snippet = {
                        expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({
                        select = true,
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                }),
            })

            -- Helper function for LSP attach
            local lsp_attach = function(_, bufnr)
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                })
            end

            -- Mason configuration
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                    "eslint",
                    "emmet_language_server",
                    "htmx",
                    "tailwindcss",
                    "clangd",
                    "ts_ls",
                },
                automatic_installation = true,
            })

            -- LSP setup helper
            local setup_lsp = function(server, opts)
                lspconfig[server].setup(vim.tbl_extend("force", {
                    on_attach = lsp_attach,
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                }, opts or {}))
            end

            -- LSP servers setup
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
            setup_lsp("ts_ls", {
            })
            setup_lsp("eslint", {
                settings = {
                    validate = "onSave",
                },
            })
            setup_lsp("clangd", {
                on_attach = function(client, bufnr)
                    client.server_capabilities.signatureHelpProvider = false
                    lsp_attach(client, bufnr)
                end,
            })
            setup_lsp("emmet_language_server", {
                filetypes = {
                    "css",
                    "eruby",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "less",
                    "sass",
                    "scss",
                    "pug",
                    "typescriptreact",
                },
                init_options = {
                    showAbbreviationSuggestions = true,
                    showExpandedAbbreviation = "always",
                },
            })
            setup_lsp("tailwindcss", {
                filetypes = {
                    "html",
                    "css",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "svelte",
                },
            })
            setup_lsp("htmx")
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "jdtls", "gopls" },
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test" },
            })
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "mfussenegger/nvim-dap" },
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Set up language servers
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })

            -- Keybindings for LSP actions
            local keymap_opts = { desc = "[C]ode [Action]" }
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, {
                desc = "[C]ode Hover Documentation",
            })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, {
                desc = "[C]ode Go to Definition",
            })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, keymap_opts)
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, {
                desc = "[C]ode Go to References",
            })
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, {
                desc = "[C]ode Go to Implementations",
            })
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, {
                desc = "[C]ode Rename",
            })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, {
                desc = "[C]ode Go to Declaration",
            })
        end,
    },
}


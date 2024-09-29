return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local function on_attach(bufnr)
            local ok, api = pcall(require, "nvim-tree.api")
            if not ok then
                vim.notify("Failed to load nvim-tree API: " .. api, vim.log.levels.ERROR)
                return
            end

            local function opts(desc)
                return {
                    desc = "nvim-tree: " .. desc,
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true
                }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set("n", "]g", api.node.navigate.git.next, opts("Next Git"))
            vim.keymap.set("n", "[g", api.node.navigate.git.prev, opts("Prev Git"))
            vim.keymap.set("n", "<leader>fe", api.tree.toggle, {
                desc = "Toggle Nvim Tree"
            })
            vim.keymap.set("n", "<c-n>", ":NvimTreeFindFileToggle<CR>", {
                desc = "Toggle Nvim Tree"
            })
            vim.keymap.set("n", "<leader>fc", api.tree.close, {
                desc = "Close Nvim Tree"
            })

            -- Custom mappings
            vim.keymap.del("n", "]c", {
                buffer = bufnr
            })
            vim.keymap.del("n", "[c", {
                buffer = bufnr
            })
        end

        require("nvim-tree").setup({
            on_attach = on_attach,
            sort_by = "case_sensitive",
            view = {
                width = {
                    min = 30,
                    max = 50
                }
            },
            renderer = {
                group_empty = true,
                root_folder_label = false
            },
            filters = {
                dotfiles = true
            }
        })
    end
}

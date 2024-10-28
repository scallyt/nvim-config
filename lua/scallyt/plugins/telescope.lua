return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {{'nvim-lua/plenary.nvim'}},
    config = function()
        -- Betöltjük a telescope.builtin modult
        local builtin = require('telescope.builtin')

        -- Billentyűparancsok beállítása
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        -- Grep keresési parancs beállítása
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({
                search = vim.fn.input("Grep > ")
            })
        end, { desc = 'Search string with Grep' })

        -- Billentyűparancsok további beállításai
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
        vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]inder [R]esume' })
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind Existing [B]uffers' })
    end
}


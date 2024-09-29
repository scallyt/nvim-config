return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {{'nvim-lua/plenary.nvim'}},
    config = function()
        -- Betöltjük a telescope.builtin modult
        local builtin = require('telescope.builtin')

        -- Billentyűparancsok beállítása
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {
            desc = 'Telescope find files'
        })
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({
                search = vim.fn.input("Grep > ")
            })
        end)
    end
}

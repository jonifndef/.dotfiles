require("telescope").setup{
    defaults = {
        layout_strategy = "flex",
        layout_config = {
            width = 0.90,
            flex = {
                flip_columns = 120,
            },
        },
    },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end
        },
        find_files = {
            hidden = true,
            no_ignore=true,
        },
    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

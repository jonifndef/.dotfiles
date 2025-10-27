vim.pack.add(
    {{ src = "https://github.com/nvim-lua/plenary.nvim.git" },},
    { confirm = false }
)

vim.pack.add(
    {{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },},
    { confirm = false }
)

vim.pack.add({
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim.git" },},
    { confirm = false }
)

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
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown()
        }
    }
}

require("telescope").load_extension("ui-select")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

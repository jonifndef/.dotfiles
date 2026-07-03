vim.pack.add(
    {{ src = "https://github.com/mikesmithgh/kitty-scrollback.nvim.git" },},
    { confirm = false }
)

require "kitty-scrollback".setup({
    {
        visual_selection_highlight_mode = 'nvim',
        --scrollback_columns = 5000,
        callbacks = {
            after_ready = function()
                vim.opt_local.wrap = true
            end,
        }
    }
})

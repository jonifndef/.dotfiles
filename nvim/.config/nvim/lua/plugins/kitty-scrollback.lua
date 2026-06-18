vim.pack.add(
    {{ src = "https://github.com/mikesmithgh/kitty-scrollback.nvim.git" },},
    { confirm = false }
)

require "kitty-scrollback".setup({})

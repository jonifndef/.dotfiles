vim.pack.add(
    {{ src = "https://github.com/mason-org/mason.nvim" },},
    { confirm = false }
)

require "mason".setup()

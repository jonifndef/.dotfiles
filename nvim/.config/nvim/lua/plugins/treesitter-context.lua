vim.pack.add(
    {{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context.git" },},
    { confirm = false }
)

require("treesitter-context").setup()

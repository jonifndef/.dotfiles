vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context.git" }
})

require("treesitter-context").setup()

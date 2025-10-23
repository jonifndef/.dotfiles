vim.pack.add(
    {{ src = "https://github.com/ellisonleao/gruvbox.nvim.git" },},
    { confirm = false }
)

require('gruvbox').setup({
    contrast = "hard",
    transparent_mode = true,
})

vim.opt.termguicolors = true
vim.cmd("colorscheme gruvbox")

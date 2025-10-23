vim.pack.add({ 'https://github.com/ellisonleao/gruvbox.nvim.git' })

require('gruvbox').setup({
    contrast = "hard",
    transparent_mode = true,
})

vim.opt.termguicolors = true
vim.cmd("colorscheme gruvbox")

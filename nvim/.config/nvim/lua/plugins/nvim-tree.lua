vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-tree.lua.git" }
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

vim.keymap.set("n", "<f12>", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fe", "<Cmd>NvimTreeFindFile<CR>", { noremap = true, silent = true })

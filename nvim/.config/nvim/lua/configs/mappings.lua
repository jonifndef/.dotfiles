vim.keymap.set("n", "<Space>", "")
vim.g.mapleader = " "
vim.keymap.set("i", "jj", "<Esc>")

-- buffers
vim.keymap.set("n", "<Right>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<Left>", ":bprevious<cr>", { silent = true })
vim.keymap.set("n", "<leader>q", ":bdelete<cr>", { silent = true })

-- scrolling
vim.keymap.set("n", "<Up>", "<C-y>")
vim.keymap.set("n", "<Down>", "<C-e>")
vim.keymap.set("n", "<S-Up>", "3<C-y>")
vim.keymap.set("n", "<S-Down>", "3<C-e>")

-- split mappings
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<C-Right>", ":vertical resize +4<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -4<CR>")
vim.keymap.set("n", "<C-Up>", ":resize -4<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +4<CR>")

-- searching
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- yank and paste
vim.keymap.set("v", "<Leader>y", '"+y')
vim.keymap.set("n", "<Leader>p", '"+p')

-- spellcheck
vim.keymap.set('n', "<leader>sc", function()
    vim.opt.spell = not(vim.opt.spell:get())
end)

-- terminal
vim.keymap.set('t', "<esc><esc>", "<C-\\><C-n>")

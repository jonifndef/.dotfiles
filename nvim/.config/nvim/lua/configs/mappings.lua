--
--                                      __
--   ___ ___      __     _____   _____ /\_\    ___      __     ____
-- /' __` __`\  /'__`\  /\ '__`\/\ '__`\/\ \ /' _ `\  /'_ `\  /',__\
-- /\ \/\ \/\ \/\ \L\.\_\ \ \L\ \ \ \L\ \ \ \/\ \/\ \/\ \L\ \/\__, `\
-- \ \_\ \_\ \_\ \__/.\_\\ \ ,__/\ \ ,__/\ \_\ \_\ \_\ \____ \/\____/
--  \/_/\/_/\/_/\/__/\/_/ \ \ \/  \ \ \/  \/_/\/_/\/_/\/___L\ \/___/
--                         \ \_\   \ \_\                /\____/
--                          \/_/    \/_/                \_/__/

vim.keymap.set("n", "<Space>", "")
vim.g.mapleader = " "

vim.keymap.set("n", "<Right>", ":bnext<cr>")
vim.keymap.set("n", "<Left>", ":bprevious<cr>")
vim.keymap.set("n", "<leader>q", ":bdelete<cr>")

vim.keymap.set("n", "<Up>", "<C-y>")
vim.keymap.set("n", "<Down>", "<C-e>")
vim.keymap.set("n", "<C-Up>", "3<C-y>")
vim.keymap.set("n", "<C-Down>", "3<C-e>")

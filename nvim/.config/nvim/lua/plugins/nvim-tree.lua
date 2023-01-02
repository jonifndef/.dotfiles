vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  auto_reload_on_write = true,
  view = {
    adaptive_size = false,
    width = 30,
    mappings = {
      list = {
        { key = "c", action = "close_node" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  --filters = {
  --  dotfiles = false,
  --},
})

vim.keymap.set("n", "<f12>", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fe", "<Cmd>NvimTreeFindFile<CR>", { noremap = true, silent = true })

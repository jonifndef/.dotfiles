vim.pack.add(
    {{ src = "https://github.com/nvim-lua/popup.nvim.git" },},
    { confirm = false }
)

vim.pack.add(
    {{ src = 'https://github.com/EthanJWright/vs-tasks.nvim.git' },},
    { confirm = false }
)

require("vstask").setup{}
require("telescope").load_extension("vstask")

vim.keymap.set('n', "<Leader>ta", require("telescope").extensions.vstask.tasks)
vim.keymap.set('n', "<Leader>ti", require("telescope").extensions.vstask.inputs)
vim.keymap.set('n', "<Leader>tj", require("telescope").extensions.vstask.jobs)
vim.keymap.set('n', "<Leader>td", require("telescope").extensions.vstask.clear_inputs)
vim.keymap.set('n', "<Leader>tc", require("telescope").extensions.vstask.cleanup_completed_jobs)
vim.keymap.set('n', "<Leader>tl", require('telescope').extensions.vstask.launch)
vim.keymap.set('n', "<Leader>tr", require('telescope').extensions.vstask.command)

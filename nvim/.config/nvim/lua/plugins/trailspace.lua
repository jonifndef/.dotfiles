vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.trailspace.git", ver = 'main' }
})

local ts = require("mini.trailspace")

ts.setup{}
vim.keymap.set('n', "<leader>tw", ts.trim)
vim.keymap.set('n', "<leader>te", ts.highlight)
vim.keymap.set('n', "<leader>td", ts.unhighlight)

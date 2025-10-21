vim.pack.add({
    { src = "https://github.com/Saghen/blink.cmp.git",
    version = vim.version.range('1.*'), },
})

require "blink.cmp".setup({
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "rust" },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

})

vim.cmd("highlight Pmenu guibg=NONE")

-- in order to solve the Ctrl-p issue in completion, add a ~/.docker/config.json with the following contents:
-- {
--     "detachKeys": "ctrl-e,e"
-- }

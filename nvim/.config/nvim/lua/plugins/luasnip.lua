vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip.git" }
})

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

ls.add_snippets("lua", {
    s("hello", {
        t('print("hello world")')
    })
})

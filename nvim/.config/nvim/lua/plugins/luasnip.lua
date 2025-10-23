vim.pack.add(
    {{ src = "https://github.com/L3MON4D3/LuaSnip.git" },},
    { confirm = false }
)

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

ls.add_snippets("cpp", {
  s("cout", {
    t('std::cout << "'),
    i(1),
    t('" << std::endl;'),
  }),
})

ls.add_snippets("cpp", {
  s("spdlog", {
    t('spdlog::'),
    i(1),
    t('("'),
    i(2),
    t('");'),
  }),
})

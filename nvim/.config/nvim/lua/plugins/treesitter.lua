vim.pack.add(
    {{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },},
    { confirm = false }
)

local configs = require('nvim-treesitter.configs')

configs.setup({
  ensure_installed = {
    'astro',
    'c',
    'cpp',
    'html',
    'http',
    'javascript',
    'json',
    'lua',
    'typescript',
    'vim',
    'vimdoc',
  },
  auto_install = true,
  modules = {},
  ignore_install = { 'org' },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  fold = { enable = true },
  playground = { ebable = true },
})

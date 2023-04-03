local servers = {
  bashls = {},
  clangd = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

require("mason").setup()
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<Leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>dn", vim.diagnostic.goto_next)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set("n", "gd", function() telescope.lsp_definitions() end)
  vim.keymap.set("n", "gr", function() telescope.lsp_references() end)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.type_definition)
  vim.keymap.set("n", "<Leader>K", vim.lsp.buf.hover)
  vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
  vim.keymap.set("n", "<Leader>co", vim.lsp.buf.code_action)
  vim.keymap.set("n", "<Leader>fo", vim.lsp.buf.format)
  --vim.keymap.set("n", "<Leader>sd", vim.lsp.buf.signature_help)

  if client.name == "clangd" then
    vim.keymap.set("n", "<Leader>o", [[<Cmd>ClangdSwitchSourceHeader<CR>]])
  end

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

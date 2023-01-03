local servers = {
  clangd = {},
  -- gopls = {},
  pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  sumneko_lua = {
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

vim.keymap.set("n", "<Leader>dp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<Leader>dn", vim.diagnostic.goto_next)

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set("n", "gd", vim.lsp.buf.definition)
  vim.keymap.set("n", "gr", vim.lsp.buf.references)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
  vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.type_definition)
  vim.keymap.set("n", "<Leader>K", vim.lsp.buf.hover)
  vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
  vim.keymap.set("n", "<Leader>co", vim.lsp.buf.code_action)
  vim.keymap.set("n", "<Leader>fo", vim.lsp.buf.format)
  --vim.keymap.set("n", "<Leader>sd", vim.lsp.buf.signature_help)

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

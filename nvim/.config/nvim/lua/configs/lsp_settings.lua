-- LSP stuff
local servers = {
    "lua_ls",
    "rust_analyzer",
    "clangd",
    "pyright"
}

vim.lsp.enable(servers)

local telescope = require("telescope.builtin")

local function set_lsp_keymaps(bufnr)
  local opts = { silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
  vim.keymap.set("n", "gr", telescope.lsp_references, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<Leader>gD", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<Leader>K",  vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<Leader>co", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<Leader>fo", vim.lsp.buf.format, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnum = args.buf
    set_lsp_keymaps(bufnum)
  end,
})

-- Diagnostics
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.o.updatetime = 200

local function hide_diagnostics()
    vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = false,
    })
end
local function show_diagnostics()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
    })
end
vim.keymap.set("n", "<leader>dh", hide_diagnostics)
vim.keymap.set("n", "<leader>ds", show_diagnostics)

vim.pack.add(
    {{ src = "https://github.com/nvim-lualine/lualine.nvim.git" },},
    { confirm = false }
)

require("lualine").setup({
    options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'lsp_status'
            }
        }
    },
    tabline = {
        lualine_a = { 'buffers' },
    }
})

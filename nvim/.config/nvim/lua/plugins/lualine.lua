vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim.git" },
})

require("lualine").setup({
    options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    tabline = {
        lualine_a = { 'buffers' },
    }
})

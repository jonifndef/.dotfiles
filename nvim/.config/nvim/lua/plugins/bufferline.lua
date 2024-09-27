require("bufferline").setup {
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon' -- | 'underline' | 'none',
        },
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        name_formatter = function(buf)
        end,
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
        end,
        custom_filter = function(buf_number, buf_numbers)
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                return true
            end
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                return true
            end
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                return true
            end
            if buf_numbers[1] ~= buf_number then
                return true
            end
        end,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            }
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        --show_buffer_default_icon = true,
        show_close_icon = false,
        show_tab_indicators = false,
        show_duplicate_prefix = true,
        persist_buffer_sort = false,
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
            enabled = false,
        },
        sort_by = 'insert_after_current'
    }
}

vim.keymap.set("n", "<Right>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<Left>", "<Cmd>BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<S-Right>", "<Cmd>BufferLineMoveNext<CR>")
vim.keymap.set("n", "<S-Left>", "<Cmd>BufferLineMovePrev<CR>")

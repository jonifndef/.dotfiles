local cmp = require("cmp")

cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-j>'] = cmp.mapping.confirm({ select = true }),
    }),

    sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "luasnip" },
        }),

    --formatting
    view = {                                                        
        entries = {name = 'custom', selection_order = 'near_cursor' } 
},              
}

cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline', keyword_length = 2 }
            })
    })

--        ___                                          
--       /\_ \                    __                   
--  _____\//\ \    __  __     __ /\_\    ___     ____  
-- /\ '__`\\ \ \  /\ \/\ \  /'_ `\/\ \ /' _ `\  /',__\ 
-- \ \ \L\ \\_\ \_\ \ \_\ \/\ \L\ \ \ \/\ \/\ \/\__, `\
--  \ \ ,__//\____\\ \____/\ \____ \ \_\ \_\ \_\/\____/
--   \ \ \/ \/____/ \/___/  \/___L\ \/_/\/_/\/_/\/___/ 
--    \ \_\                   /\____/                  
--     \/_/                   \_/__/                   
-- 

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable 'make' == 1
    }
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        {run = ':TSUpdate'}
    }
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons'
    }
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }
    use "onsails/lspkind.nvim"
end)

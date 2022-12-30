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
    use 'ellisonleao/gruvbox.nvim'
    use 'nvim-tree/nvim-web-devicons'
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
end)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- lib
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  {
    'rcarriga/nvim-notify',
    config = function() require('plugins.configs.notify') end,
  },

  -- dressing ui improvement
  {
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        input = {
          mappings = {
            n = {
              ['vv'] = 'Close',
            },
          },
        },
        select = {
          backend = { 'telescope', 'nui', 'builtin' },
        },
      })
    end,
  },

  -- fzf
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    config = function() require('plugins.configs.telescope') end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    config = function() require('telescope').load_extension('fzf') end,
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    config = function() require('telescope').load_extension('frecency') end,
  },

  -- show register content
  {
    'tversteeg/registers.nvim',
    config = function() require('registers').setup() end,
  },

  -- icon
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    config = function() require('plugins.configs.icons') end,
  },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    config = function() require('plugins.configs.lualine') end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- smart split
  {
    'mrjones2014/smart-splits.nvim',
  },

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    config = function() require('plugins.configs.nvim-tree') end,
  },

  -- manage buffers
  {
    'akinsho/bufferline.nvim',
    config = function() require('plugins.configs.bufferline') end,
  },

  -- indent tracing
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function() require('plugins.configs.indent-blankline') end,
  },

  -- highlight colors
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function() require('plugins.configs.colorizer') end,
  },

  -- LSP
  -- lspkind pictogram
  'onsails/lspkind.nvim',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- lsp signature when typing
      -- "ray-x/lsp_signature.nvim",
    },
    config = function() require('plugins.configs.lspconfig') end,
  },

  -- rust
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function() require('plugins.configs.cmp') end,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'kdheepak/cmp-latex-symbols',
    },
  },

  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function() require('plugins.configs.copilot') end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function() require('copilot_cmp').setup() end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require('plugins.configs.treesitter') end,
  },

  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    config = function() require('plugins.configs.avante') end,
    build = 'make',
    dependencies = {
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        'OXY2DEV/markview.nvim',
        enabled = true,
        lazy = false,
        ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
        opts = {
          preview = {
            filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
            ignore_buftypes = {},
          },
        },
      },
    },
  },

  -- vim plugins
  'tpope/vim-surround',

  'farmergreg/vim-lastplace',

  -- enhanced dot command
  'tpope/vim-repeat',

  -- editorconfig
  'editorconfig/editorconfig-vim',

  -- extra text objects
  'wellle/targets.vim',

  -- Bdelete without destroy our layout
  'moll/vim-bbye',

  -- theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function() require('plugins.configs.tokyonight') end,
  },

  -- theme similar to vscode default dark
  {
    'lunarvim/darkplus.nvim',
  },
})

---@diagnostic disable: undefined-field

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

  -- better ui
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    config = function() require('plugins.configs.noice') end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
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
  {
    'MagicDuck/grug-far.nvim',
    config = function() require('plugins.configs.grug-far') end,
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
  'mrjones2014/smart-splits.nvim',

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
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
    event = 'BufReadPre',
    opts = {},
    config = function() require('plugins.configs.indent-blankline') end,
  },

  -- highlight colors
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufRead',
    config = function() require('plugins.configs.colorizer') end,
  },

  -- LSP
  -- lspkind pictogram
  'onsails/lspkind.nvim',

  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      -- lsp signature when typing
      -- "ray-x/lsp_signature.nvim",
    },
    config = function() require('plugins.configs.lspconfig') end,
  },

  -- rust
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
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
      'kdheepak/cmp-latex-symbols',
      'zbirenbaum/copilot-cmp',
    },
  },

  -- copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = not vim.env.HEADLESS,
    config = function() require('plugins.configs.copilot') end,
  },
  {
    'zbirenbaum/copilot-cmp',
    enabled = not vim.env.HEADLESS,
    config = function() require('copilot_cmp').setup() end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPre',
    config = function() require('plugins.configs.treesitter') end,
    branch = 'master',
  },

  -- extra text objects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- enhance textobjects
  'tpope/vim-surround',

  -- theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },

  {
    'cocopon/iceberg.vim',
    lazy = false,
    priority = 1000,
    config = function() require('plugins.configs.theme') end,
  },

  -- theme similar to vscode default dark
  {
    'lunarvim/darkplus.nvim',
    lazy = false,
    priority = 1000,
  },
})

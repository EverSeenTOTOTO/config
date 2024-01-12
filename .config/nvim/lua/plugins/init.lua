local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- lib
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "MunifTanjim/nui.nvim",
  {
    "rcarriga/nvim-notify",
    config = function()
      require("plugins.configs.notify")
    end,
  },

  -- dressing
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          mappings = {
            n = {
              ["vv"] = "Close",
            },
          },
        },
        select = {
          backend = { "telescope", "nui", "builtin" },
        },
      })
    end,
  },

  -- fzf
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = function()
      require("plugins.configs.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },

  -- show register content
  {
    "tversteeg/registers.nvim",
    config = function()
      require("registers").setup()
    end,
  },

  -- icon
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
    config = function()
      require("plugins.configs.icons")
    end,
  },

  -- statusline
  {
    "feline-nvim/feline.nvim",
    config = function()
      require("plugins.configs.feline")
    end,
  },

  -- smart split
  {
    "mrjones2014/smart-splits.nvim",
  },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.configs.nvim-tree")
    end,
  },

  -- manage buffers
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  -- indent tracing
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("plugins.configs.indent-blankline")
    end,
  },

  -- highlight colors
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("plugins.configs.colorizer")
    end,
  },

  -- LSP
  -- lspkind pictogram
  "onsails/lspkind.nvim",

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/lsp_signature.nvim",
      "simrat39/rust-tools.nvim",
    },
    config = function()
      require("plugins.configs.lspconfig")
    end,
  },

  -- lsp signature when typing
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("plugins.configs.lsp_signature")
    end,
  },

  -- rust
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup({})
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("plugins.configs.cmp")
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      "kdheepak/cmp-latex-symbols",
    },
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          markdown = false
        },
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- autopair
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.configs.autopairs")
    end,
  },

  -- remember last edit position
  { "vladdoster/remember.nvim", lazy = false },

  -- vim plugins
  "tpope/vim-surround",

  -- enhanced dot command
  "tpope/vim-repeat",

  -- editorconfig
  "editorconfig/editorconfig-vim",

  -- extra text objects
  "wellle/targets.vim",

  -- Bdelete without destroy our layout
  "moll/vim-bbye",

  -- theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        on_colors = function(colors)
          colors.comment = '#a09a91'
        end,
        on_highlights = function(highlights)
          highlights.DiagnosticUnnecessary = {
            fg = "#a09a91"
          }
        end
      })
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },

  -- theme similar to vscode default dark
  {
    "lunarvim/darkplus.nvim",
  },
})

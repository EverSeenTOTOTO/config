local present = pcall(require, "packer")

if not present then
  local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

  print("Cloning packer to " .. packer_path)
  -- remove the dir before cloning
  vim.fn.delete(packer_path, "rf")
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    "--depth",
    "1",
    packer_path,
  })

  vim.api.nvim_command('packadd packer.nvim')
end

require("packer").startup(function(use)
  -- lib
  use { "nvim-lua/plenary.nvim" }

  -- fast boot
  use { "lewis6991/impatient.nvim" }

  -- pkg manager
  use { "wbthomason/packer.nvim",
    event = "VimEnter",
  }

  -- show register content
  use { 'tversteeg/registers.nvim',
    config = function()
      require('registers').setup()
    end,
  }

  -- icon
  use { "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugins.configs.icons")
    end,
  }

  -- lspkind pictogram
  use { "onsails/lspkind.nvim" }

  -- statusline
  use { "feline-nvim/feline.nvim",
    after = "nvim-web-devicons",
    config = function()
      require("plugins.configs.feline")
    end,
  }

  -- manage buffers
  use { "akinsho/bufferline.nvim",
    after = "nvim-web-devicons",

    setup = function()
      require("core.mappings").bufferline()
    end,

    config = function()
      require("plugins.configs.bufferline")
    end,
  }

  -- indent tracing
  use { "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("plugins.configs.indent-blankline")
    end,
  }

  -- Notification Enhancer
  use { "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      require("plugins.configs.notify")
    end,
  }

  -- highlight colors
  use { "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("plugins.configs.colorizer")
    end,
  }

  -- LSP
  use { "neovim/nvim-lspconfig",
    module = "lspconfig",
    setup = function()
      vim.defer_fn(function()
        require("packer").loader("nvim-lspconfig")
      end, 0)
    end,
    config = function()
      require("plugins.configs.lspconfig")
    end,
  }

  -- lsp signature when typing
  use { "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("plugins.configs.lsp_signature")
    end,
  }

  -- ts
  use {
    after = "nvim-lspconfig",
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup({})
    end
  }

  -- rust
  use {
    after = "nvim-lspconfig",
    'simrat39/rust-tools.nvim',
    config = function()
      require('rust-tools').setup({})
    end
  }

  -- lisp
  use { 'gpanders/nvim-parinfer', }


  -- Completion
  use { "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.configs.cmp")
    end,
  }

  -- snippets
  use { "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.luasnip")
    end,
  }

  use { "saadparwaiz1/cmp_luasnip",
    after = "LuaSnip",
  }

  -- tabnine
  use { 'tzachar/cmp-tabnine',
    run = './install.sh',
    after = "nvim-cmp",
    requires = 'hrsh7th/nvim-cmp',
    config = function()
      require("plugins.configs.tabnine")
    end
  }

  -- lsp
  use { "hrsh7th/cmp-nvim-lsp",
    after = "nvim-cmp",
  }

  use { "hrsh7th/cmp-buffer",
    after = "nvim-cmp",
  }

  use { "hrsh7th/cmp-path",
    after = "nvim-cmp",
  }

  use { "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
  }

  use { "hrsh7th/cmp-emoji",
    after = "nvim-cmp",
  }

  use { "kdheepak/cmp-latex-symbols",
    after = "nvim-cmp",
  }

  -- neovim lua api source
  use { "hrsh7th/cmp-nvim-lua",
    after = "nvim-cmp",
  }

  -- Github copilot
  -- use { "zbirenbaum/copilot.lua",
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup()
  --     end, 100)
  --   end,
  -- },

  -- use { "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua", "nvim-cmp" },
  --   branch = "master",
  -- },

  -- remember last edit position
  use { "vladdoster/remember.nvim", }

  -- fzf
  use { "nvim-telescope/telescope.nvim",
    cmd = "Telescope",

    setup = function()
      require("core.mappings").telescope()
    end,

    config = function()
      require("plugins.configs.telescope")
    end,
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }

  use { "nvim-telescope/telescope-frecency.nvim",
    after = 'telescope.nvim',
    requires = { "kkharji/sqlite.lua" },
    config = function()
      require "telescope".load_extension("frecency")
    end,
  }

  -- vim plugins
  use { "christoomey/vim-tmux-navigator", }
  use { "tpope/vim-surround", }
  use { "tpope/vim-repeat", }
  use { "wellle/targets.vim", }

  -- iceberg theme
  use { "cocopon/iceberg.vim", }
end)

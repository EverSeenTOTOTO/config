local present, packer = pcall(require, "plugins.packerInit")

if not present then
  return false
end

local plugins = {
  -- lib
  ["nvim-lua/plenary.nvim"] = {},
  ["lewis6991/impatient.nvim"] = {},

  -- pkg manager
  ["wbthomason/packer.nvim"] = {
    event = "VimEnter",
  },

  -- icon
  ["kyazdani42/nvim-web-devicons"] = {
    config = function()
      require "plugins.configs.icons"
    end,
  },

  -- statusline
  ["feline-nvim/feline.nvim"] = {
    after = "nvim-web-devicons",
    config = function()
      require "plugins.configs.statusline"
    end,
  },

  -- manage buffers
  ["akinsho/bufferline.nvim"] = {
    after = "nvim-web-devicons",

    setup = function()
      require("core.mappings").bufferline()
    end,

    config = function()
      require "plugins.configs.bufferline"
    end,
  },

  -- speed up indent detection
  ["Darazaki/indent-o-matic"] = {
    event = "BufReadPost",
    config = function()
      require "plugins.configs.indent-o-matic"
    end,
  },

  -- indent tip
  ["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufRead",
    config = function()
      require "plugins.configs.indent-blankline"
    end,
  },

  -- Notification Enhancer
  ["rcarriga/nvim-notify"] = {
    event = "VimEnter",
    config = function()
      require "plugins.configs.notify"
    end,
  },

  -- Cursorhold fix
  ["antoinemadec/FixCursorHold.nvim"] = {
    event = { "BufRead", "BufNewFile" },
    config = function()
      vim.g.cursorhold_updatetime = 100
    end,
  },

  -- Better buffer closing
  ["famiu/bufdelete.nvim"] = { cmd = { "Bdelete", "Bwipeout" } },

  -- code highlighting
  ["norcalli/nvim-colorizer.lua"] = {
    event = "BufRead",
    config = function()
      require "plugins.configs.colorizer"
    end,
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    event = { "BufRead", "BufNewFile" },
    run = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- LSP
  ["neovim/nvim-lspconfig"] = {
    module = "lspconfig",
    setup = function()
      require("core.utils").packer_lazy_load "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- lsp signature when typing
  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "plugins.configs.lsp_signature"
    end,
  },

  -- % match syntax words
  ["andymass/vim-matchup"] = {
    opt = true,
    setup = function()
      require("core.utils").packer_lazy_load "vim-matchup"
    end,
  },

  -- smooth esc
  ["max397574/better-escape.nvim"] = {
    event = "InsertCharPre",
    config = function()
      require "plugins.configs.better-escape"
    end,
  },

  -- Completion
  ["hrsh7th/nvim-cmp"] = {
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  ["L3MON4D3/LuaSnip"] = {
    after = "nvim-cmp",
    config = function()
      require "plugins.configs.luasnip"
    end,
  },

  ["saadparwaiz1/cmp_luasnip"] = {
    after = "LuaSnip",
  },

  ["hrsh7th/cmp-nvim-lua"] = {
    after = "cmp_luasnip",
  },

  ["hrsh7th/cmp-nvim-lsp"] = {
    after = "cmp-nvim-lua",
  },

  ["hrsh7th/cmp-buffer"] = {
    after = "cmp-nvim-lsp",
  },

  ["hrsh7th/cmp-path"] = {
    after = "cmp-buffer",
  },

  ["hrsh7th/cmp-cmdline"] = {
    after = "cmp-path",
  },

  ["hrsh7th/cmp-emoji"] = {
    after = "cmp-cmdline",
  },

  ["kdheepak/cmp-latex-symbols"] = {
    after = "nvim-cmp",
  },

  -- Github copilot
  -- ["zbirenbaum/copilot.lua"] = {
  --   event = { "VimEnter" },
  --   config = function()
  --     vim.defer_fn(function()
  --       require("copilot").setup()
  --     end, 100)
  --   end,
  -- },

  -- ["zbirenbaum/copilot-cmp"] = {
  --   after = { "copilot.lua", "nvim-cmp" },
  --   branch = "master",
  -- },

  -- fzf
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",

    setup = function()
      require("core.mappings").telescope()
    end,

    config = function()
      require "plugins.configs.telescope"
    end,
  },

  -- vim plugins
  ["christoomey/vim-tmux-navigator"] = {},
  ["tpope/vim-surround"] = {},

  -- iceberg theme
  ["cocopon/iceberg.vim"] = {},
}

local plugin_list = function(default_plugins)
  local final_table = {}

  for key, _ in pairs(default_plugins) do
    default_plugins[key][1] = key

    final_table[#final_table + 1] = default_plugins[key]
  end

  return final_table
end

return packer.startup(function(use)
  for _, v in pairs(plugin_list(plugins)) do
    use(v)
  end
end)

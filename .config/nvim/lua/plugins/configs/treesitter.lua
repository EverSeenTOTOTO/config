local configs = require('nvim-treesitter.configs')

configs.setup({
  ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'html' },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["am"] = "@comment.outer",
        ["im"] = "@comment.inner",
        ["ao"] = "@loop.outer",
        ["io"] = "@loop.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["as"] = { query = "@local.scope", query_group = "locals" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]b"] = "@block.outer",
        ["]m"] = "@comment.outer",
        ["]o"] = "@loop.outer",
        ["]p"] = "@parameter.outer",
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {},
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[b"] = "@block.outer",
        ["[m"] = "@comment.outer",
        ["[o"] = "@loop.outer",
        ["[p"] = "@parameter.outer",
        ["[s"] = { query = "@local.scope", query_group = "locals", desc = "Prev scope" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
      },
      goto_previous_end = {},
    },
  },
})


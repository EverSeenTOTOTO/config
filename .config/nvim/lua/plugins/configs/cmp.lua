local present, cmp = pcall(require, "cmp")

if not present then
  return
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local cmp_window = require "cmp.utils.window"
local luasnip = require "luasnip"

function cmp_window:has_scrollbar()
  return false
end

local options = {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  window = {
    completion = {
      border = border "CmpBorder",
    },
    documentation = {
      border = border "CmpDocBorder",
    },
  },
  formatting = {
    format = function(entry, vim_item)
      --icon
      local icons = require "plugins.configs.lspkind_icons"
      local kind = icons[vim_item.kind]

      vim_item.kind = string.format("%s %s", kind.icon, kind.name)

      -- Source
      vim_item.menu = ({
        -- copilot = "[Copilot]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
        nvim_lua = "[Lua]",
        path = "[Path]",
        cmdline = "[Cmdline]",
        emoji = "[Emoji]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]

      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
  },
  sources = {
    -- { name = "copilot" },
    { name = "nvim_lsp", },
    { name = "luasnip", },
    { name = "buffer", },
    { name = "nvim_lua", },
    { name = "path", },
    { name = "cmdline", },
    { name = "emoji", },
    { name = "latex_symbols", },
  },
}

cmp.setup(options)
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

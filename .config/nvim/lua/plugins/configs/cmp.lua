local present, cmp = pcall(require, "cmp")

if not present then
  return
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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

local source_mapping = {
  cmp_tabnine = "[TN]",
  copilot = "[Copilot]",
  luasnip = "[LuaSnip]",
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  path = "[Path]",
  nvim_lua = "[Lua]",
}

local luasnip = require("luasnip")
local lspkind = require("lspkind")
local compare = require('cmp.config.compare')

local options = {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  preselect = cmp.PreselectMode.None,
  window = {
    completion = {
      border = border("CmpBorder"),
    },
    documentation = {
      border = border("CmpDocBorder"),
    },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol' })
      vim_item.menu = source_mapping[entry.source.name];

      if entry.source.name == "cmp_tabnine" then
        local detail = (entry.completion_item.data or {}).detail

        vim_item.kind = ""

        if detail and detail:find('.*%%.*') then
          vim_item.kind = vim_item.kind .. ' ' .. detail
        end

        if (entry.completion_item.data or {}).multiline then
          vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
        end
      end

      if entry.source.name == 'path' then
        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)

        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          return vim_item
        end
      end

      vim_item.abbr = string.sub(vim_item.abbr, 1, 80)

      return vim_item
    end,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require('cmp_tabnine.compare'),
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
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
    { name = "cmp_tabnine" },
    { name = "nvim_lsp" },
    { name = "luasnip", max_item_count = 3 },
    { name = "buffer", max_item_count = 5, keyword_length = 5 },
    { name = "nvim_lua" },
    { name = "path", max_item_count = 5 },
    { name = "emoji" },
    { name = "latex_symbols" },
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
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

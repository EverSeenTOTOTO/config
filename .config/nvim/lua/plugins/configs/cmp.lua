local present, cmp = pcall(require, 'cmp')
if not present then return end

local function border(hl_name)
  return {
    { '╭', hl_name },
    { '─', hl_name },
    { '╮', hl_name },
    { '│', hl_name },
    { '╯', hl_name },
    { '─', hl_name },
    { '╰', hl_name },
    { '│', hl_name },
  }
end

local source_mapping = {
  copilot = '[Copilot]',
  buffer = '[Buffer]',
  nvim_lsp = '[LSP]',
  path = '[Path]',
  vsnip = '[Snippet]',
}

local comparators = {

  -- Below is the default comparitor list and order for nvim-cmp
  cmp.config.compare.offset,
  -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
  cmp.config.compare.exact,
  cmp.config.compare.score,
  cmp.config.compare.recently_used,
  cmp.config.compare.locality,
  cmp.config.compare.kind,
  cmp.config.compare.sort_text,
  cmp.config.compare.length,
  cmp.config.compare.order,
}

if not vim.env.HEADLESS and not vim.g.vscode then
  table.insert(comparators, 1, require('copilot_cmp.comparators').prioritize)
end

local lspkind = require('lspkind')

local has_words_before = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  if not cursor or #cursor == 0 then return false end

  local line, col = unpack(cursor)
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local options = {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
    end,
  },
  -- preselect = cmp.PreselectMode.None,
  performance = {
    debounce = 150,
  },
  view = {
    docs = {
      auto_open = true,
    },
    entries = {
      selection_order = 'near_cursor',
      follow_cursor = true,
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  experimental = {
    ghost_text = true,
  },
  window = {
    completion = {
      border = border('CmpBorder'),
    },
    documentation = {
      border = border('CmpDocBorder'),
    },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = 'symbol' })
      vim_item.menu = source_mapping[entry.source.name]

      if entry.source.name == 'copilot' then
        local detail = (entry.completion_item.data or {}).detail

        vim_item.kind = ''

        if detail and detail:find('.*%%.*') then vim_item.kind = vim_item.kind .. ' ' .. detail end

        if (entry.completion_item.data or {}).multiline then vim_item.kind = vim_item.kind .. ' ' .. '[ML]' end
      end

      if entry.source.name == 'path' then
        local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)

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
    comparators,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<CR>'] = cmp.mapping({
      i = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
      c = cmp.mapping.confirm({ select = false }),
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'copilot', group_index = 1 },
    {
      name = 'nvim_lsp',
      keyword_length = 2,
      group_index = 1,
      --- see https://github.com/vuejs/language-tools/discussions/4495
      ---@param entry cmp.Entry
      ---@param ctx cmp.Context
      entry_filter = function(entry, ctx)
        -- Check if the buffer type is 'vue'
        if ctx.filetype ~= 'vue' then return true end

        local cursor_before_line = ctx.cursor_before_line
        -- For events
        if cursor_before_line:sub(-1) == '@' then
          return entry.completion_item.label:match('^@')
          -- For props also exclude events with `:on-` prefix
        elseif cursor_before_line:sub(-1) == ':' then
          return entry.completion_item.label:match('^:') and not entry.completion_item.label:match('^:on%-')
        else
          return true
        end
      end,
    },
    { name = 'vsnip' },
    {
      name = 'buffer',
      keyword_length = 3,
      group_index = 2,
    },
    {
      name = 'path',
    },
    { name = 'emoji' },
    { name = 'latex_symbols' },
  },
}

cmp.setup(options)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

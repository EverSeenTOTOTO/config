local M = {}

local function sanitize_line(line)
  return string.gsub(tostring(line.title or line.name or line.label or line), '\n', ' ')
end

local function format_codeaction(opts, defaults, items)
  local entry_display = require('telescope.pickers.entry_display')
  local finders = require('telescope.finders')

  -- Calculate widths for proper alignment
  local client_width = 1
  local text_width = 1
  local idx_width = 1

  -- Process items to determine display widths
  local entries = {}
  for idx, item in ipairs(items) do
    -- Get client ID based on Neovim version
    local client_id
    if vim.fn.has('nvim-0.10') == 1 then
      client_id = item.ctx.client_id
    else
      client_id = item[1]
    end

    local client_name = vim.lsp.get_client_by_id(client_id).name
    local text = opts.format_item(item.action)

    -- Update max widths
    client_width = math.max(client_width, vim.api.nvim_strwidth(client_name))
    text_width = math.max(text_width, vim.api.nvim_strwidth(text))
    idx_width = math.max(idx_width, vim.api.nvim_strwidth(tostring(idx)))

    table.insert(entries, {
      idx = idx,
      text = text,
      client_name = client_name,
      ordinal = idx .. ' ' .. text .. ' ' .. client_name,
      value = item,
    })
  end

  -- Create display formatter with calculated widths
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = idx_width + 1 },
      { width = text_width },
      { width = client_width },
    },
  })

  -- Attach display function to each entry
  for _, entry in ipairs(entries) do
    entry.display = function(e)
      local columns = {
        { e.idx .. ':', 'TelescopePromptPrefix' },
        e.text,
        { e.client_name, 'Comment' },
      }
      return displayer(columns)
    end
  end

  -- Update defaults with custom finder
  defaults.finder = finders.new_table({
    results = entries,
    entry_maker = function(item) return item end,
  })
end

---Custom kinds for different selection types
local custom_kinds = {
  codeaction = format_codeaction,
}

local function create_entry_maker(opts)
  return function(item)
    local formatted = opts.format_item(item)
    return {
      display = formatted,
      ordinal = formatted,
      value = item,
    }
  end
end

local function create_selection_handler(prompt_bufnr, items, on_choice)
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')

  return function()
    local selection = state.get_selected_entry()
    local callback = on_choice
    -- Replace on_choice with a no-op so closing doesn't trigger it
    on_choice = function(_, _) end
    actions.close(prompt_bufnr)

    if not selection then
      -- User did not select anything.
      callback(nil, nil)
      return
    end

    local idx = nil
    for i, item in ipairs(items) do
      if item == selection.value then
        idx = i
        break
      end
    end

    callback(selection.value, idx)
  end
end

local function setup_telescope_picker(config, items, opts, on_choice)
  local themes = require('telescope.themes')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values

  local picker_opts = config or themes.get_dropdown()

  local defaults = {
    prompt_title = opts.prompt,
    previewer = false,
    finder = finders.new_table({
      results = items,
      entry_maker = create_entry_maker(opts),
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      local actions = require('telescope.actions')

      -- Replace default selection action
      actions.select_default:replace(create_selection_handler(prompt_bufnr, items, on_choice))

      actions.close:enhance({
        post = function() on_choice(nil, nil) end,
      })

      return true
    end,
  }

  if opts.kind and custom_kinds[opts.kind] then custom_kinds[opts.kind](opts, defaults, items) end

  if opts.telescope then
    pickers.new(opts.telescope, defaults):find()
  else
    pickers.new(picker_opts, defaults):find()
  end
end

local function make_queued_async_fn(callback_arg_num, fn)
  local queue = {}
  local consuming = false

  local function consume()
    if #queue == 0 then
      consuming = false
      return
    end
    consuming = true
    local args = table.remove(queue, 1)
    fn(vim.F.unpack_len(args))
  end

  return function(...)
    local args = vim.F.pack_len(...)
    local cb = args[callback_arg_num]
    args[callback_arg_num] = function(...)
      local cb_args = vim.F.pack_len(...)
      vim.schedule(function()
        -- first schedule the consumption, only later invoke
        -- the callback, because the callback could fail
        vim.schedule(consume)
        cb(vim.F.unpack_len(cb_args))
      end)
    end
    table.insert(queue, args)
    if not consuming then consume() end
  end
end

M.select = vim.schedule_wrap(make_queued_async_fn(3, function(items, opts, on_choice)
  vim.validate({
    items = {
      items,
      function(a) return type(a) == 'table' and vim.islist(a) end,
      'list-like table',
    },
    on_choice = { on_choice, 'function', false },
  })

  opts = opts or {}
  opts.prompt = vim.trim(sanitize_line(opts.prompt or 'Select one of:'))
  opts.format_item = sanitize_line

  -- Save window state to restore after selection
  local winid = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(winid)

  setup_telescope_picker(
    nil,
    items,
    opts,
    vim.schedule_wrap(function(...)
      -- Restore window state
      if vim.api.nvim_win_is_valid(winid) then vim.api.nvim_win_set_cursor(winid, cursor) end
      on_choice(...)
    end)
  )
end))

return M

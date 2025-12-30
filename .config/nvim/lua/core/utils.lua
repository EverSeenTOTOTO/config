local M = {}

M.exclude_filetypes = {
  'PlenaryTestPopup',
  'checkhealth',
  'dbout',
  'gitsigns-blame',
  'grug-far',
  'help',
  'lspinfo',
  'neotest-output',
  'neotest-output-panel',
  'neotest-summary',
  'notify',
  'qf',
  'spectre_panel',
  'startuptime',
  'tsplayground',
  'noice',
  'dapui-scopes',
  'dapui-breakpoints',
  'dapui-watches',
  'dap-repl',
  'dapui-console',
  'dapui-stacks',
  'NvimTree',
  'Telescope',
}

M.is_special_filetype = function(buf) return vim.tbl_contains(M.exclude_filetypes, vim.bo[buf].filetype) end

-- Generate content hash for buffer integrity checking
local function generate_content_hash(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')
  return vim.fn.sha256(content)
end

-- Lightweight version: save only current window state (recommended for formatting)
function M.save_bufstate_lite(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  return {
    bufnr = bufnr,
    view = vim.fn.winsaveview(),
    content_hash = generate_content_hash(bufnr),
    timestamp = vim.uv.hrtime(),
  }
end

-- Full version: save comprehensive state (use only when needed)
function M.save_bufstate(bufnr, options)
  options = options or {}
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local state = {
    bufnr = bufnr,
    content_hash = generate_content_hash(bufnr),
    timestamp = vim.uv.hrtime(),
  }

  -- Always save current window view
  state.view = vim.fn.winsaveview()

  -- Save all windows only if explicitly requested
  if options.save_all_windows then
    state.windows = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
        state.windows[win] = vim.api.nvim_win_get_cursor(win)
      end
    end
  end

  -- Save marks only if explicitly requested
  if options.save_marks then
    state.marks = {}

    -- Only save marks that actually exist to avoid unnecessary iterations
    local mark_ranges = {
      { string.byte('a'), string.byte('z') }, -- local marks
    }

    if options.save_global_marks then
      table.insert(mark_ranges, { string.byte('A'), string.byte('Z') }) -- global marks
    end

    for _, range in ipairs(mark_ranges) do
      for i = range[1], range[2] do
        local mark_name = string.char(i)
        local mark_pos = vim.api.nvim_buf_get_mark(bufnr, mark_name)
        if mark_pos and mark_pos[1] > 0 then state.marks[mark_name] = mark_pos end
      end
    end

    -- Save important special marks if requested
    if options.save_special_marks then
      local special_marks = { '"', "'", '[', ']', '<', '>' }
      for _, mark_name in ipairs(special_marks) do
        local mark_pos = vim.api.nvim_buf_get_mark(bufnr, mark_name)
        if mark_pos and mark_pos[1] > 0 then state.marks[mark_name] = mark_pos end
      end
    end
  end

  return state
end

-- Smart buffer close function
-- Handles modified buffers, special filetypes, and maintains window layout
function M.close_buffer(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  if M.is_special_filetype(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
    return
  end

  -- copy from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua
  vim.api.nvim_buf_call(buf, function()
    if vim.bo.modified then
      local ok, choice = pcall(vim.fn.confirm, ('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
      if not ok or choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
        return
      end
      if choice == 1 then -- Yes
        vim.cmd.write()
      end
    end

    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.api.nvim_win_call(win, function()
        if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then return end

        -- Try using alternate buffer
        local alt = vim.fn.bufnr('#')
        if alt ~= buf and vim.fn.buflisted(alt) == 1 then
          vim.api.nvim_win_set_buf(win, alt)
          return
        end

        -- Try using previous buffer
        local has_previous = pcall(vim.cmd, 'bprevious')
        if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then return end

        -- Create new listed buffer
        local new_buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_win_set_buf(win, new_buf)
      end)
    end

    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end)
end

-- Lightweight restore: restore only view state with integrity check
function M.restore_bufstate_lite(saved_state)
  if not saved_state or not saved_state.view then return false, 'Invalid saved state' end

  local bufnr = saved_state.bufnr or vim.api.nvim_get_current_buf()

  -- Verify buffer is still valid and hasn't changed
  if not vim.api.nvim_buf_is_valid(bufnr) then return false, 'Buffer no longer valid' end

  -- Check content integrity if hash is available
  if saved_state.content_hash then
    local current_hash = generate_content_hash(bufnr)
    if current_hash ~= saved_state.content_hash then return false, 'Buffer content has changed' end
  end

  -- Restore view with safety checks
  local view = vim.tbl_deep_extend('keep', saved_state.view, {
    lnum = 1,
    col = 0,
    topline = 1,
  })

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  view.lnum = math.max(1, math.min(view.lnum, line_count))
  view.topline = math.max(1, math.min(view.topline, line_count))

  vim.fn.winrestview(view)
  return true, 'State restored successfully'
end

-- Full restore: restore comprehensive state with integrity check
function M.restore_bufstate(bufnr, saved_state, options)
  options = options or {}

  if not saved_state then return false, 'No saved state provided' end

  bufnr = bufnr or saved_state.bufnr or vim.api.nvim_get_current_buf()

  -- Verify buffer is still valid
  if not vim.api.nvim_buf_is_valid(bufnr) then return false, 'Buffer no longer valid' end

  -- Check content integrity if hash is available and not disabled
  if not options.skip_integrity_check and saved_state.content_hash then
    local current_hash = generate_content_hash(bufnr)
    if current_hash ~= saved_state.content_hash then
      if not options.force_restore then
        return false, 'Buffer content has changed, use force_restore=true to override'
      end
    end
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Helper function to clamp position to buffer bounds
  local function clamp_position(pos)
    local line = math.max(1, math.min(pos[1], line_count))
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ''
    local col = math.max(0, math.min(pos[2], #line_content))
    return { line, col }
  end

  -- Restore view state (primary method)
  if saved_state.view then
    local view = vim.tbl_deep_extend('keep', saved_state.view, {
      lnum = 1,
      col = 0,
      topline = 1,
    })

    view.lnum = math.max(1, math.min(view.lnum, line_count))
    view.topline = math.max(1, math.min(view.topline, line_count))

    vim.fn.winrestview(view)
  end

  -- Restore cursor positions for all windows (legacy support)
  if saved_state.windows then
    for win, cursor in pairs(saved_state.windows) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
        local clamped_cursor = clamp_position(cursor)
        vim.api.nvim_win_set_cursor(win, clamped_cursor)
      end
    end
  end

  -- Restore fold state (legacy support)
  if saved_state.folds then
    for win, win_view in pairs(saved_state.folds) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
        -- Clamp the view position to current buffer bounds
        win_view.lnum = math.max(1, math.min(win_view.lnum or 1, line_count))
        win_view.topline = math.max(1, math.min(win_view.topline or 1, line_count))

        vim.api.nvim_win_call(win, function() vim.fn.winrestview(win_view) end)
      end
    end
  end

  -- Restore marks
  if saved_state.marks then
    for mark_name, pos in pairs(saved_state.marks) do
      local clamped_pos = clamp_position(pos)
      local ok, err = pcall(vim.api.nvim_buf_set_mark, bufnr, mark_name, clamped_pos[1], clamped_pos[2], {})
      if not ok and options.warn_on_mark_failure then
        vim.notify("Failed to restore mark '" .. mark_name .. "': " .. err, vim.log.levels.WARN)
      end
    end
  end

  return true, 'State restored successfully'
end

return M

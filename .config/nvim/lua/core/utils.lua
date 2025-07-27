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
}

-- Save cursor position and marks for a buffer
function M.save_bufstate(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Save cursor positions for all windows displaying this buffer
  local windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then windows[win] = vim.api.nvim_win_get_cursor(win) end
  end

  -- Save marks
  local marks = {}

  -- Local marks (a-z)
  for i = string.byte('a'), string.byte('z') do
    local mark_name = string.char(i)
    local mark_pos = vim.api.nvim_buf_get_mark(bufnr, mark_name)
    if mark_pos and mark_pos[1] > 0 then -- if mark exists
      marks[mark_name] = mark_pos
    end
  end

  -- Capital marks (A-Z) that might be in this buffer
  for i = string.byte('A'), string.byte('Z') do
    local mark_name = string.char(i)
    local mark_pos = vim.api.nvim_buf_get_mark(bufnr, mark_name)
    if mark_pos and mark_pos[1] > 0 then -- if mark exists in this buffer
      marks[mark_name] = mark_pos
    end
  end

  -- Special marks
  local special_marks = { '"', "'", '[', ']', '<', '>' }
  for _, mark_name in ipairs(special_marks) do
    local mark_pos = vim.api.nvim_buf_get_mark(bufnr, mark_name)
    if mark_pos and mark_pos[1] > 0 then -- if mark exists
      marks[mark_name] = mark_pos
    end
  end

  -- Save fold state for windows displaying this buffer
  local folds = {}
  for win in pairs(windows) do
    if vim.api.nvim_win_is_valid(win) then
      local win_view = vim.api.nvim_win_call(win, vim.fn.winsaveview)
      folds[win] = win_view
    end
  end

  return {
    windows = windows,
    marks = marks,
    folds = folds,
  }
end

-- Restore cursor position and marks for a buffer
function M.restore_bufstate(bufnr, saved_state)
  if not saved_state then return end

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Helper function to clamp position to buffer bounds
  local function clamp_position(pos)
    local line = math.max(1, math.min(pos[1], line_count))
    local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ''
    local col = math.max(0, math.min(pos[2], #line_content))
    return { line, col }
  end

  -- Restore cursor positions for all windows
  if saved_state.windows then
    for win, cursor in pairs(saved_state.windows) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
        local clamped_cursor = clamp_position(cursor)
        vim.api.nvim_win_set_cursor(win, clamped_cursor)
      end
    end
  end

  -- Restore fold state
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
      vim.api.nvim_buf_set_mark(bufnr, mark_name, clamped_pos[1], clamped_pos[2], {})
    end
  end
end

return M

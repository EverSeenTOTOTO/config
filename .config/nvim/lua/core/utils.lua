local M = {}

-- Save cursor position and marks for a buffer
function M.save_bufstate(bufnr)
  -- Save cursor position
  local cursor = vim.api.nvim_win_get_cursor(0)

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

  return {
    cursor = cursor,
    marks = marks,
  }
end

-- Restore cursor position and marks for a buffer
function M.restore_bufstate(bufnr, saved_state)
  local cursor = saved_state.cursor
  local marks = saved_state.marks

  -- Only set cursor if we're in the same window with the buffer
  local win = vim.fn.bufwinid(bufnr)

  if win == -1 then return end

  -- Check if cursor is out of range (after formatting)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local line = math.min(cursor[1], line_count)
  local col = cursor[2]

  -- Clamp column to line length
  local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ''
  if col > #line_content then col = #line_content end

  vim.api.nvim_win_set_cursor(win, { line, col })

  -- Restore marks
  for mark_name, pos in pairs(marks) do
    -- Ensure mark position is within buffer bounds
    local mark_line = math.min(pos[1], line_count)
    local mark_col = pos[2]

    -- Clamp column to line length
    local mark_line_content = vim.api.nvim_buf_get_lines(bufnr, mark_line - 1, mark_line, false)[1]
    if mark_line_content then
      if mark_col > #mark_line_content then mark_col = #mark_line_content end
      vim.api.nvim_buf_set_mark(bufnr, mark_name, mark_line, mark_col, {})
    end
  end
end

return M

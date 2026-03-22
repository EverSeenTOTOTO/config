local M = {}
local spinner = require('core.ui.spinner')

-- Define formatters in priority order (highest priority first)
local formatters_priority = {
  'biome',
  'eslint',
  'vtsls',
}
local priority_map = {}
for i, formatter in ipairs(formatters_priority) do
  priority_map[formatter] = i
end

-- Save view state: cursor, folds, marks
local function save_state(bufnr)
  -- Save local marks
  local marks = {}
  for _, m in pairs(vim.fn.getmarklist(bufnr)) do
    if m.mark:match("^'[a-z]$") then
      marks[m.mark:sub(2, 2)] = { m.pos[2], m.pos[3] - 1 } -- api-indexed
    end
  end

  -- Save fold state: for each fold, store [start, end] pairs
  local folds = {}
  local foldmethod = vim.wo.foldmethod
  if foldmethod == 'manual' or foldmethod == 'marker' then
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local i = 1
    while i <= line_count do
      local fold_start = vim.fn.foldclosed(i)
      if fold_start ~= -1 then
        -- Line is inside a closed fold, find the end
        local fold_end = vim.fn.foldclosedend(i)
        table.insert(folds, { fold_start, fold_end })
        i = fold_end + 1
      else
        i = i + 1
      end
    end
  end

  -- Use winsaveview for comprehensive view state
  local view = vim.fn.winsaveview()

  return {
    marks = marks,
    folds = folds,
    view = view,
    foldmethod = foldmethod,
  }
end

-- Restore view state after formatting
local function restore_state(bufnr, state, old_line_count)
  local new_line_count = vim.api.nvim_buf_line_count(bufnr)

  -- Restore marks with line adjustment
  local marks_still_exist = {}
  for _, m in pairs(vim.fn.getmarklist(bufnr)) do
    marks_still_exist[m.mark:sub(2, 2)] = true
  end

  for mark, pos in pairs(state.marks) do
    if not marks_still_exist[mark] and pos then
      -- Scale line number proportionally if total lines changed
      local new_line = pos[1]
      if old_line_count > 0 and new_line_count ~= old_line_count then
        new_line = math.floor(pos[1] * new_line_count / old_line_count)
      end
      new_line = math.max(1, math.min(new_line, new_line_count))
      local line_text = vim.api.nvim_buf_get_lines(bufnr, new_line - 1, new_line, false)[1] or ''
      local new_col = math.min(pos[2], #line_text)
      vim.api.nvim_buf_set_mark(bufnr, mark, new_line, new_col, {})
    end
  end

  -- Adjust view cursor position proportionally
  local view = state.view
  if old_line_count > 0 and new_line_count ~= old_line_count then
    view.lnum = math.max(1, math.min(math.floor(view.lnum * new_line_count / old_line_count), new_line_count))
    view.topline = math.max(1, math.min(math.floor(view.topline * new_line_count / old_line_count), new_line_count))
  end

  -- Restore view (cursor, topline, etc.) without adding to jumplist
  -- winrestview doesn't add to jumplist, so it's safe to use
  vim.fn.winrestview(view)

  -- Restore folds for manual/marker foldmethod
  if (state.foldmethod == 'manual' or state.foldmethod == 'marker') and #state.folds > 0 then
    -- Clear existing folds first
    vim.cmd('normal! zE')
    -- Recreate folds with proportional line adjustment
    for _, fold in ipairs(state.folds) do
      local new_start = fold[1]
      local new_end = fold[2]
      if old_line_count > 0 and new_line_count ~= old_line_count then
        new_start = math.max(1, math.floor(fold[1] * new_line_count / old_line_count))
        new_end = math.min(new_line_count, math.floor(fold[2] * new_line_count / old_line_count))
      end
      if new_start < new_end then vim.cmd(string.format('%d,%dfold', new_start, new_end)) end
    end
  end
  -- For indent/expr/syntax foldmethod, folds are recalculated automatically
end

local lsp_format = function(callback)
  local buf = vim.api.nvim_get_current_buf()
  local active_clients = vim.lsp.get_clients({ bufnr = buf })

  if #active_clients == 0 then
    callback('No lsp clients')
    return
  end

  -- Find the single best formatter
  local best_client = nil
  local best_priority = #formatters_priority + 1

  for _, client in ipairs(active_clients) do
    local p = priority_map[client.name] or (#formatters_priority + 1)
    if p < best_priority then
      best_priority = p
      best_client = client
    end
  end

  if not best_client then
    callback('No suitable formatter found')
    return
  end

  -- Save state before formatting
  local old_line_count = vim.api.nvim_buf_line_count(buf)
  local state = save_state(buf)

  vim.lsp.buf.format({
    async = false,
    bufnr = buf,
    filter = function(client) return client.name == best_client.name end,
    timeout_ms = 5000,
  })

  -- Restore state after formatting
  restore_state(buf, state, old_line_count)

  -- Only run organizeImports if vtsls is the chosen formatter (not eslint/biome)
  if best_client.name == 'vtsls' then
    best_client:request('workspace/executeCommand', {
      command = 'typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = '',
    }, callback)
    return
  end

  callback()
end

local prettier_format = function(callback)
  local bin_path = vim.fn.finddir('node_modules/.bin', vim.fn.getcwd() .. ';')
  local prettier_path = bin_path .. '/prettier'

  if not (bin_path ~= '' and vim.fn.filereadable(prettier_path) == 1) then
    callback()
    return
  end

  -- Store the buffer number at the beginning of the function
  local bufnr = vim.api.nvim_get_current_buf()
  local current_file_path = vim.fn.expand('%:p')

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local old_line_count = #lines
  local state = save_state(bufnr)

  local stderr_data = {}
  local stdout_data = {}

  local function collect_data(data, target)
    if not data then return end
    for _, line in ipairs(data) do
      table.insert(target, line)
    end
  end

  local job = vim.fn.jobstart(prettier_path .. ' --stdin-filepath ' .. current_file_path, {
    on_stdout = function(_, data) collect_data(data, stdout_data) end,
    on_stderr = function(_, data) collect_data(data, stderr_data) end,
    on_exit = function(_, exitcode)
      if exitcode ~= 0 then
        -- Show error notification
        local error_msg = table.concat(stderr_data, '\n')
        vim.notify('Prettier error: ' .. error_msg, vim.log.levels.ERROR)
        callback('Formatting failed')
        return
      end

      if not vim.api.nvim_buf_is_valid(bufnr) then
        callback('Formatting cancelled: invalid buffer')
        return
      end

      -- Check if buffer content has changed during formatting
      local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local content_changed = false
      if #current_lines ~= #lines then
        content_changed = true
      else
        for i, line in ipairs(lines) do
          if line ~= current_lines[i] then
            content_changed = true
            break
          end
        end
      end

      if content_changed then
        callback('Formatting cancelled: buffer was modified')
        return
      end

      -- Apply formatted content
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stdout_data)

      -- Restore state after formatting
      restore_state(bufnr, state, old_line_count)

      callback()
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  -- Send buffer content to prettier
  vim.fn.chansend(job, lines)
  vim.fn.chanclose(job, 'stdin')
end

M.format = function()
  spinner.start('Formatting')

  lsp_format(function(lsp_error)
    if lsp_error then
      spinner.stop(lsp_error)
    else
      prettier_format(function(prettier_error)
        if prettier_error then
          spinner.stop(prettier_error)
        else
          spinner.stop('Formated')
        end
      end)
    end
  end)
end

return M

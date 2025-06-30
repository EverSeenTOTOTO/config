local M = {}
local spinner = require('core.spinner')

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

function M.lsp_format()
  local buf = vim.api.nvim_get_current_buf()
  local active_clients = vim.lsp.get_clients({ bufnr = buf })

  if #active_clients == 0 then return end

  vim.lsp.buf.format({
    async = false,
    bufnr = buf,
    filter = function(client)
      -- If client is not in priority list, give it lowest priority
      local client_priority = priority_map[client.name] or (#formatters_priority + 1)

      -- Find the highest priority formatter that's actually available
      local best_priority = #formatters_priority + 1
      for _, c in ipairs(active_clients) do
        local p = priority_map[c.name] or (#formatters_priority + 1)
        if p < best_priority then best_priority = p end
      end

      -- Only use this client if it has the best available priority
      return client_priority <= best_priority
    end,
    timeout_ms = 5000,
  })
end

function M.prettier_format()
  -- Store the buffer number at the beginning of the function
  local bufnr = vim.api.nvim_get_current_buf()

  local bin_path = vim.fn.finddir('node_modules/.bin', vim.fn.getcwd() .. ';')

  if bin_path == '' then return end

  local prettier_path = bin_path .. '/prettier'

  -- Check if prettier executable exists
  if vim.fn.filereadable(prettier_path) ~= 1 then return end

  local current_file_path = vim.fn.expand('%:p')

  -- Save cursor position and buffer content
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local stderr_data = {}
  local stdout_data = {}
  local function collect_data(data, target)
    if not data then return end
    for _, line in ipairs(data) do
      table.insert(target, line)
    end
  end

  spinner.start('Formatting...')

  local job = vim.fn.jobstart(prettier_path .. ' --stdin-filepath ' .. current_file_path, {
    on_stdout = function(_, data) collect_data(data, stdout_data) end,
    on_stderr = function(_, data) collect_data(data, stderr_data) end,
    on_exit = function(_, exitcode)
      if exitcode == 0 and #stdout_data > 0 then
        -- Check if buffer is still valid and matches the original buffer
        if not vim.api.nvim_buf_is_valid(bufnr) then
          spinner.stop('Formatting cancelled')
          return
        end

        -- Check if there's any difference between current content and formatted content
        local has_diff = false
        if #lines ~= #stdout_data then
          has_diff = true
        else
          for i, line in ipairs(lines) do
            if line ~= stdout_data[i] then
              has_diff = true
              break
            end
          end
        end

        -- Only update buffer if there are actual changes
        if has_diff then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stdout_data)

          -- Check if cursor is out of range (after formatting)
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          local line = math.min(cursor[1], line_count)
          local col = cursor[2]
          -- Clamp column to line length
          local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ''
          if col > #line_content then col = #line_content end

          -- Only set cursor if we're in the same window with the buffer
          local win = vim.fn.bufwinid(bufnr)
          if win ~= -1 then vim.api.nvim_win_set_cursor(win, { line, col }) end
        end
      elseif exitcode ~= 0 then
        -- Show error notification
        local error_msg = table.concat(stderr_data, '\n')
        vim.notify('Prettier error: ' .. error_msg, vim.log.levels.ERROR)
      end

      spinner.stop('Formated')
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  -- Send buffer content to prettier
  vim.fn.chansend(job, lines)
  vim.fn.chanclose(job, 'stdin')
end

function M.format_all()
  M.lsp_format()
  M.prettier_format()
end

return M

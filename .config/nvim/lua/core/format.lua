local M = {}
local spinner = require('core.ui.spinner')
local utils = require('core.utils')

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

  -- Save cursor position, marks
  local state = utils.save_bufstate(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

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
        spinner.stop('Formatting failed')
        return
      end

      if not vim.api.nvim_buf_is_valid(bufnr) then
        spinner.stop('Formatting cancelled: invalid buffer')
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
        spinner.stop('Formatting cancelled: dirty buffer')
        return
      end

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stdout_data)

      -- Restore cursor and marks
      utils.restore_bufstate(bufnr, state)
      spinner.stop('Formatted')
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  -- Send buffer content to prettier
  vim.fn.chansend(job, lines)
  vim.fn.chanclose(job, 'stdin')
end

function M.format_all()
  spinner.start('Formatting...')
  M.lsp_format()
  M.prettier_format()
end

return M

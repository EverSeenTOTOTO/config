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

local lsp_format = function(callback)
  local buf = vim.api.nvim_get_current_buf()
  local active_clients = vim.lsp.get_clients({ bufnr = buf })

  if #active_clients == 0 then
    callback('No lsp clients')
    return
  end

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
    5000,
  })

  for _, client in ipairs(active_clients) do
    if client.name == 'vtsls' then
      client:request('workspace/executeCommand', {
        command = 'typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = '',
      }, callback)
      return
    end
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

      -- save and restore local marks since they get deleted by nvim_buf_set_lines, see: vim.lsp.util.apply_text_edits
      local marks = {}
      for _, m in pairs(vim.fn.getmarklist(bufnr)) do
        if m.mark:match("^'[a-z]$") then
          marks[m.mark:sub(2, 2)] = { m.pos[2], m.pos[3] - 1 } -- api-indexed
        end
      end

      -- Apply formatted content
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stdout_data)

      -- no need to restore marks that still exist
      local max = vim.api.nvim_buf_line_count(bufnr)
      for _, m in pairs(vim.fn.getmarklist(bufnr)) do
        marks[m.mark:sub(2, 2)] = nil
      end
      -- restore marks
      for mark, pos in pairs(marks) do
        if pos then
          -- make sure we don't go out of bounds
          pos[1] = math.min(pos[1], max)
          pos[2] = math.min(pos[2], #(vim.lsp.util.get_line(bufnr, pos[1] - 1) or ''))
          vim.api.nvim_buf_set_mark(bufnr or 0, mark, pos[1], pos[2], {})
        end
      end

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

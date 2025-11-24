local create_usercmd = vim.api.nvim_create_user_command
local utils = require('core.utils')

create_usercmd('TsOrganizeImports', function()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == 'vtsls' then
      client:request('workspace/executeCommand', {
        command = 'typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = '',
      })
    end
  end
end, {})

create_usercmd('SplitCurrentLine', function()
  vim.ui.input({
    prompt = 'Separator: ',
    default = ' ',
  }, function(sep)
    local cursor = vim.api.nvim_win_get_cursor(0)

    if not cursor or not sep then return end

    local buf = vim.api.nvim_get_current_buf()
    local row, col = unpack(cursor)
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
    local lines = vim.split(line, sep:gsub('^%s*(.-)%s*$', '%1'):gsub('^$', ' '), {
      plain = true,
      trimempty = true,
    })

    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row, col })
  end)
end, {})

create_usercmd('ChangeEncodingAndReload', function()
  vim.ui.input({
    prompt = 'Encoding: ',
    default = 'gbk',
  }, function(enc)
    local original_enc = vim.opt.fileencoding:get()
    vim.cmd(':e ++enc=' .. enc)
    vim.opt.fileencoding = enc
    vim.notify('Changing encoding from ' .. original_enc(' to ') .. enc, vim.log.levels.INFO, {
      title = 'User Command',
    })
  end)
end, {})

-- Close all buffers to the left of the current buffer
create_usercmd('BufferCloseLeft', function()
  local bufs = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_get_current_buf()
  local found_cur = false

  for _, buf in ipairs(bufs) do
    if buf == cur_buf then
      found_cur = true
    elseif
      not found_cur
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value('buflisted', {
        buf = buf,
      })
    then
      -- Buffer is to the left of current buffer
      utils.close_buffer(buf)
    end
  end
end, {})

-- Close all buffers to the right of the current buffer
create_usercmd('BufferCloseRight', function()
  local bufs = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_get_current_buf()
  local found_cur = false

  for _, buf in ipairs(bufs) do
    if buf == cur_buf then
      found_cur = true
    elseif
      found_cur
      and buf ~= cur_buf
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value('buflisted', {
        buf = buf,
      })
    then
      -- Buffer is to the right of current buffer
      utils.close_buffer(buf)
    end
  end
end, {})

-- Close all buffers except the current one
create_usercmd('BufferCloseOthers', function()
  local bufs = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(bufs) do
    if
      buf ~= cur_buf
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_get_option_value('buflisted', {
        buf = buf,
      })
    then
      utils.close_buffer(buf)
    end
  end
end, {})

-- copy from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua
local M = {}

--- Delete a buffer:
--- - either the current buffer if `buf` is not provided
--- - or the buffer `buf` if it is a number
--- - or every buffer for which `buf` returns true if it is a function
function M.delete(opts)
  opts = opts or {}
  opts = type(opts) == 'number' and { buf = opts } or opts
  opts = type(opts) == 'function' and { filter = opts } or opts

  if type(opts.filter) == 'function' then
    for _, b in ipairs(vim.tbl_filter(opts.filter, vim.api.nvim_list_bufs())) do
      if vim.bo[b].buflisted then M.delete(vim.tbl_extend('force', {}, opts, { buf = b, filter = false })) end
    end
    return
  end

  local buf = opts.buf or 0
  if opts.file then
    buf = vim.fn.bufnr(opts.file)
    if buf == -1 then return end
  end
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  vim.api.nvim_buf_call(buf, function()
    if vim.bo.modified and not opts.force then
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
    if vim.api.nvim_buf_is_valid(buf) then pcall(vim.cmd, (opts.wipe and 'bwipeout! ' or 'bdelete! ') .. buf) end
  end)
end

return M

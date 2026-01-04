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

function M.is_special_filetype(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.tbl_contains(M.exclude_filetypes, vim.bo[buf].filetype)
end

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

return M

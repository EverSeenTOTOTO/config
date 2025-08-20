local dap = require('dap')
local dap_view = require('dap-view')

dap_view.setup({
  winbar = {
    default_section = 'scopes',
    sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
  },
})

dap.listeners.after['event_process']['my_keymap_plugin'] = function()
  vim.keymap.set('n', 'gc', dap.continue, { desc = 'DAP: Continue' })
  vim.keymap.set('n', 'gi', dap.step_into, { desc = 'DAP: Step Into' })
  vim.keymap.set('n', 'go', dap.step_out, { desc = 'DAP: Step Out' })
  vim.keymap.set('n', 'gg', dap.step_over, { desc = 'DAP: Step Over' })
  vim.keymap.set('n', 'gt', dap.terminate, { desc = 'DAP: Terminate' })
  vim.keymap.set('n', 'gs', '<cmd> :DapViewToggle <CR>')
end
dap.listeners.before['event_terminated']['my-keymap-plugin'] = function()
  vim.keymap.del('n', 'gc')
  vim.keymap.del('n', 'gi')
  vim.keymap.del('n', 'go')
  vim.keymap.del('n', 'gg')
  vim.keymap.del('n', 'gt')
  vim.keymap.del('n', 'gs')
end

local function get_python_binary()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
    return cwd .. '/venv/bin/python'
  elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
    return cwd .. '/.venv/bin/python'
  else
    return '/usr/bin/python'
  end
end

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    -- Find venv in current workspace
    cb({
      type = 'executable',
      command = get_python_binary(),
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end
dap.configurations.python = {
  {
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = get_python_binary,
  },
}

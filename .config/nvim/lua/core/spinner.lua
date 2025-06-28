local M = {}

local Message = require('noice.message')
local manager = require('noice.message.manager')
local formatter = require('noice.text.format')

local timer = nil
local start = 0
local msg = nil

M.start = function(message)
  if timer then
    vim.fn.timer_stop(timer)
    timer = nil
  end

  start = vim.fn.reltime()

  msg = Message('msg_show', 'spinner')
  msg.opts.content = message

  timer = vim.fn.timer_start(
    80,
    function()
      manager.add(formatter.format(msg, {
        { '{spinner} ', hl_group = 'NoiceLspProgressSpinner' },
        { '{data.content}', hl_group = 'NoiceLspProgressTitle' },
      }))
    end,
    { ['repeat'] = -1 }
  ) -- -1 means repeat indefinitely
end

M.stop = function(message)
  if not timer then return end

  vim.fn.timer_stop(timer)
  timer = nil
  msg.opts.content = message or msg.opts.content
  manager.add(formatter.format(msg, {
    { '✔ ', hl_group = 'NoiceLspProgressSpinner' },
    { '{data.content}', hl_group = 'NoiceLspProgressTitle' },
  }))

  local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start))

  vim.defer_fn(function()
    manager.clear({
      kind = 'spinner',
    })
    msg = nil
  end, 300 - math.floor(elapsed * 1000)) -- elapsed at least 300ms
end

return M

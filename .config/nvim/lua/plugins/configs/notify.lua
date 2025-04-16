local status_ok, notify = pcall(require, 'notify')

if status_ok then
  notify.setup({
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
    fps = 60,
    timeout = 4000,
    stages = 'slide',
    on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
  })
  vim.notify = notify
end

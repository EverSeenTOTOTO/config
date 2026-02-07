local utils = require('core.utils')
-- Helper function for mapping keys
local map = function(mode, keys, command, opt)
  local options = { silent = true }

  if opt then options = vim.tbl_extend('force', options, opt) end

  if type(keys) == 'table' then
    for _, keymap in ipairs(keys) do
      vim.keymap.set(mode, keymap, command, options)
    end
    return
  end

  vim.keymap.set(mode, keys, command, options)
end

-- MAPPINGS

-- Leader
vim.g.mapleader = ','
map('', '<space>', ':', { silent = false })
map({ 'n', 'i' }, 'vv', '<esc>')

-- 行号
map('n', '<F4>', ':se nu! nu?<CR>')

-- 防止缩进取消选择
map('v', '<', '<gv')
map('v', '>', '>gv')

-- 折行
map('n', 'k', 'gk')
map('n', 'gk', 'k')
map('n', 'j', 'gj')
map('n', 'gj', 'j')

-- search
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', '*', '*zz')
map('n', '#', '#zz')
map('n', 'g*', 'g*zz')

-- HL
map({ 'v', 'n' }, 'H', 'g^')
map({ 'v', 'n' }, 'L', 'g$')

-- redo
map('n', 'U', '<C-r>', { noremap = true })

-- Alt + jk move lines
if vim.fn.has('mac') ~= 0 then
  map('n', '∆', "<cmd>execute 'move .+' . v:count1<cr>==")
  map('i', '∆', '<esc><cmd>m .+1<cr>==gi')
  map('v', '∆', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
  map('n', '˚', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==")
  map('i', '˚', '<esc><cmd>m .-2<cr>==gi')
  map('v', '˚', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")
else
  map('n', '<M-j>', "<cmd>execute 'move .+' . v:count1<cr>==")
  map('i', '<M-j>', '<esc><cmd>m .+1<cr>==gi')
  map('v', '<M-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv")
  map('n', '<M-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==")
  map('i', '<M-k>', '<esc><cmd>m .-2<cr>==gi')
  map('v', '<M-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv")
end

-- Don't copy the replaced text after pasting in visual mode
map('v', 'p', 'p:let @+=@0<CR>')

-- use ESC to turn off search highlighting
map('n', '<Esc>', '<cmd>:noh<CR>')

-- move cursor within insert mode
map({ 'i', 'c' }, '<C-a>', '<Home>')
map({ 'i' }, '<C-b>', '<esc>bi')
map({ 'i', 'c' }, '<C-e>', '<End>')
map({ 'i' }, '<C-f>', '<esc>ea')
map({ 'i', 'v', 'c' }, '<C-h>', '<Left>')
map({ 'i', 'v' }, '<C-j>', '<Down>')
map({ 'i', 'v' }, '<C-k>', '<Up>')
map({ 'i', 'v', 'c' }, '<C-l>', '<Right>')
map('i', '<C-o>', '<esc>O')

map('n', '<leader>z', '$zf%')

-- terminal
map('t', 'vv', '<C-\\><C-n>')

-- cycle cnext and cprevious
map('n', ']q', function()
  local qflist = vim.fn.getqflist({ items = 1 }).items or {}

  if #qflist == 0 then return end

  local idx = vim.fn.getqflist({ idx = 0 }).idx or 1

  if idx == #qflist then
    vim.fn.setqflist({}, 'r', { idx = 1 }) -- reset idx to 1 if at the end
    vim.cmd('cc')
  else
    vim.cmd('cnext')
  end
end)
map('n', '[q', function()
  local qflist = vim.fn.getqflist({ items = 1 }).items or {}

  if #qflist == 0 then return end

  local idx = vim.fn.getqflist({ idx = 0 }).idx or #qflist

  if idx == 1 then
    vim.fn.setqflist({}, 'r', { idx = #qflist })
    vim.cmd('cc')
  else
    vim.cmd('cprevious')
  end
end)
map('n', ']l', function()
  local loclist = vim.fn.getloclist(0, { items = 1 }).items or {}

  if #loclist == 0 then return end

  local idx = vim.fn.getloclist(0, { idx = 0 }).idx or 1

  if idx == #loclist then
    vim.fn.setloclist(0, {}, 'r', { idx = 1 }) -- reset idx to 1 if at the end
    vim.cmd('ll')
  else
    vim.cmd('lnext')
  end
end)
map('n', '[l', function()
  local loclist = vim.fn.getloclist(0, { items = 1 }).items or {}

  if #loclist == 0 then return end

  local idx = vim.fn.getloclist(0, { idx = 0 }).idx or #loclist

  if idx == 1 then
    vim.fn.setloclist(0, {}, 'r', { idx = #loclist })
    vim.cmd('ll')
  else
    vim.cmd('lprevious')
  end
end)

-- plugin mappings
map('n', '<leader>f', require('core.utils.format').format)

map('n', '<leader>h', function()
  vim.lsp.buf.hover()
  vim.defer_fn(vim.lsp.buf.hover, 300)
end)

map('n', '<leader>n', function() vim.lsp.buf.rename() end)
map('n', '<leader>a', function() vim.lsp.buf.code_action() end)

map('n', '<leader>[', function()
  vim.diagnostic.jump({
    count = -1,
    float = true,
  })
end)
map('n', '<leader>]', function()
  vim.diagnostic.jump({
    count = 1,
    float = true,
  })
end)

-- treesitter
local ts_utils = require('nvim-treesitter.ts_utils')

local node_with_range = {
  block = true,
  class_definition = true,
  function_definition = true,
  arrow_function = true,
  if_statement = true,
  switch_statement = true,
  for_statement = true,
  while_statement = true,
  element = true,
  jsx_element = true,
  jsx_self_closing_element = true,
  script_element = true,
  string = true,
  template_string = true,
}

map('', '<leader><leader>', function()
  local _row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row(1-base), col(0-base)
  local row = _row - 1
  local line = vim.api.nvim_get_current_line()
  local char = line:sub(col + 1, col + 1) -- 光标下字符
  local defaults = {
    ['('] = true,
    [')'] = true,
    ['['] = true,
    [']'] = true,
    ['{'] = true,
    ['}'] = true,
  }

  if defaults[char] then
    vim.cmd('normal! %')
    return
  end

  local node = ts_utils.get_node_at_cursor()

  while node and not node_with_range[node:type()] do
    node = node:parent()
  end

  if not node then return end

  local sr, sc = node:start() -- 0-base
  local er, ec = node:end_()  -- 0-base

  if row == sr then
    vim.api.nvim_win_set_cursor(0, { er + 1, ec })
  else
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
  end
  if sr == er then vim.api.nvim_win_set_cursor(0, { er + 1, col == sc and ec or sc }) end
end)

-- redirect command line output
map('c', '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end)

map({ 'n', 'v' }, '<TAB>', '<cmd> :BufferLineCycleNext <CR>')
map({ 'n', 'v' }, '<S-Tab>', '<cmd> :BufferLineCyclePrev <CR>')
map({ 'n', 'v' }, '<C-s>', '<cmd> :Telescope live_grep<CR>')
map({ 'n', 'v' }, '<C-b>', '<cmd> :Telescope buffers<CR>')
map(
  { 'n', 'v' },
  'ss',
  function() require('grug-far').open({ prefills = { flags = '-.', paths = vim.fn.expand('%') } }) end
)
map({ 'n', 'v' }, '//', '<cmd> :Telescope current_buffer_fuzzy_find<CR>')
map({ 'n', 'v' }, '<C-p>', '<cmd> :Telescope commands <CR>')
map({ 'n', 'v' }, '<C-f>', '<cmd> :Telescope find_files<CR>')
map({ 'n', 'v' }, '<C-q>', '<cmd> :Telescope quickfix<CR>')
map({ 'n', 'v' }, '<Space><Space>', '<cmd> :Telescope command_history<CR>')
map('i', '<C-r>', '<cmd> :Telescope registers<CR>')

map('n', '<leader>d', '<cmd> :Telescope lsp_definitions <CR>')
map('n', '<leader>i', '<cmd> :Telescope lsp_implementations <CR>')
map('n', '<leader>r', '<cmd> :Telescope lsp_references <CR>')
map('n', '<leader>t', '<cmd> :Telescope lsp_type_definitions <CR>')
map('n', '<leader>q', utils.close_buffer)
map('n', '<C-x>', '<cmd> :BufferLineCloseOthers<CR>')

-- 窗口
map('', '<up>', function() require('smart-splits').resize_up() end)
map('', '<down>', function() require('smart-splits').resize_down() end)
map('', '<left>', function() require('smart-splits').resize_left() end)
map('', '<right>', function() require('smart-splits').resize_right() end)
map('n', '<C-h>', function() require('smart-splits').move_cursor_left() end)
map('n', '<C-j>', function() require('smart-splits').move_cursor_down() end)
map('n', '<C-k>', function() require('smart-splits').move_cursor_up() end)
map('n', '<C-l>', function() require('smart-splits').move_cursor_right() end)

-- 智能关闭分屏：关闭分屏的同时，如果该分屏的buffer与当前面板不一致，则同时关闭该buffer
local function smart_close_split(direction)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  -- 移动到目标分屏
  vim.cmd('wincmd ' .. direction)

  -- 检查是否成功移动到了另一个窗口
  if vim.api.nvim_get_current_win() ~= current_win then
    local target_win = vim.api.nvim_get_current_win()
    local target_buf = vim.api.nvim_get_current_buf()

    -- 检查是否是特殊窗口类型
    local win_config = vim.api.nvim_win_get_config(target_win)
    local is_special_win = win_config.relative ~= '' -- floating window
    local buftype = vim.bo[target_buf].buftype

    -- 特殊窗口直接关闭
    if is_special_win or buftype ~= '' or utils.is_special_filetype(target_buf)
        -- 如果目标分屏的buffer与原来的不同，也直接关闭
        or target_buf ~= current_buf
    then
      vim.cmd('wincmd c')
      vim.cmd('wincmd p')
      utils.close_buffer(target_buf)
      return
    end

    -- 只关闭窗口
    vim.cmd('wincmd c')
    vim.cmd('wincmd p')
  end
end

map('', 'd<up>', function() smart_close_split('k') end)
map('', 'd<down>', function() smart_close_split('j') end)
map('', 'd<left>', function() smart_close_split('h') end)
map('', 'd<right>', function() smart_close_split('l') end)

-- file explorer
map('', '<C-c>', function()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()

  if node ~= nil then
    if node.type == 'directory' then
      vim.api.nvim_set_current_dir(node.absolute_path)
      api.tree.change_root_to_node(node)
    else
      local abs_path = node == nil and api.tree.get_nodes().absolute_path or node.absolute_path
      local parent_path = vim.fs.dirname(abs_path)

      vim.api.nvim_set_current_dir(parent_path)
      api.tree.change_root(parent_path)
    end
  end
end)

map('', '<C-t>', function()
  local api = require('nvim-tree.api')

  if not api.tree.is_visible() then
    if not utils.is_special_filetype() and vim.bo.buftype == '' then
      api.tree.find_file({ open = true, focus = false })
    else
      api.tree.toggle()
    end
  else
    api.tree.close()
  end
end)

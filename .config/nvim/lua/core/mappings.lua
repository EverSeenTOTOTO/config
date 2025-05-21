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

map('', '<leader><leader>', '%')
map('', '<space>', ':', { silent = false })
map({ 'n', 'i' }, 'vv', '<esc>')

-- 行号
map('n', '<F2>', ':se nu! nu?<CR>')

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
map('n', 'U', '<C-r>')

-- Alt + jk move lines
if vim.fn.has('mac') ~= 0 then
  map('n', '∆', 'mz:m+<cr>`z')
  map('i', '∆', '<esc>mz:m+<cr>`zi')
  map('v', '∆', ":m'>+<cr>`<my`>mzgv`yo`z")
  map('i', '˚', '<esc>mz:m-2<cr>`zi')
  map('n', '˚', 'mz:m-2<cr>`z')
  map('v', '˚', ":m'<-2<cr>`>my`<mzgv`yo`z")
else
  map('n', '<M-j>', 'mz:m+<cr>`z')
  map('i', '<M-j>', '<esc>mz:m+<cr>`zi')
  map('v', '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z")
  map('i', '<M-k>', '<esc>mz:m-2<cr>`zi')
  map('n', '<M-k>', 'mz:m-2<cr>`z')
  map('v', '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z")
end

-- Don't copy the replaced text after pasting in visual mode
map('v', 'p', 'p:let @+=@0<CR>')

-- use ESC to turn off search highlighting
map('n', '<Esc>', '<cmd>:noh<CR>')

-- move cursor within insert mode
map('i', '<C-a>', '<Home>')
map('i', '<C-b>', '<esc>bi')
map('i', '<C-e>', '<End>')
map('i', '<C-f>', '<esc>ea')
map({ 'i', 'v' }, '<C-h>', '<Left>')
map({ 'i', 'v' }, '<C-j>', '<Down>')
map({ 'i', 'v' }, '<C-k>', '<Up>')
map({ 'i', 'v' }, '<C-l>', '<Right>')
map('i', '<C-o>', '<esc>O')

map('n', '<leader>z', '$zf%')

-- terminal
map('t', 'vv', '<C-\\><C-n>')

-- plugin mappings

local function lsp_format()
  -- lsp
  local allowed_order_map = {
    'biome',
    'eslint',
    'vtsls',
  }

  vim.lsp.buf.format({
    async = false,
    filter = function(current)
      -- lsp format, sort by allowed_order_map
      local all_clients = vim.lsp.get_clients({ bufnr = 0 })
      local first_allowed_index = #allowed_order_map
      local current_index = 0

      -- create a map for faster lookup
      local client_map = {}
      for _, c in ipairs(all_clients) do
        client_map[c.name] = c
      end

      for i, allowed in ipairs(allowed_order_map) do
        if client_map[allowed] and first_allowed_index > i then -- found first allowed client
          first_allowed_index = i
        end
        if current.name == allowed then -- found current
          current_index = i
        end
        if current_index ~= 0 then break end
      end

      return current_index <= first_allowed_index
    end,
  })
end

local function prettier_format()
  -- prettier
  local prettier_path = vim.fn.finddir('node_modules/.bin', vim.fn.getcwd() .. ';') .. '/prettier'
  local current_file_path = vim.fn.expand('%:p')

  if vim.uv.fs_stat(prettier_path) then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local job = vim.fn.jobstart(prettier_path .. ' --stdin-filepath ' .. current_file_path, {
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(0, 0, -1, false, data)
          vim.api.nvim_win_set_cursor(0, cursor)
        end
      end,
      on_exit = function(_, exitcode)
        if exitcode == 0 then vim.api.nvim_win_set_cursor(0, cursor) end
      end,
      stdout_buffered = true,
    })
    vim.fn.chansend(job, lines)
    vim.fn.chanclose(job, 'stdin')
  end
end

map('n', '<leader>f', function()
  lsp_format()
  prettier_format()
end)

map('n', '<leader>h', function()
  vim.lsp.buf.hover()
  vim.lsp.buf.hover() -- call twice to jump to float window
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

map({ 'n', 'v' }, '<TAB>', '<cmd> :BufferLineCycleNext <CR>')
map({ 'n', 'v' }, '<S-Tab>', '<cmd> :BufferLineCyclePrev <CR>')
map({ 'n', 'v' }, 'ss', '<cmd> :Telescope live_grep<CR>')
map({ 'n', 'v' }, '<C-b>', '<cmd> :Telescope buffers<CR>')
map({ 'n', 'v' }, '//', '<cmd> :Telescope current_buffer_fuzzy_find <CR>')
map({ 'n', 'v' }, '<C-p>', '<cmd> :Telescope commands <CR>')
map(
  { 'n', 'v' },
  '<C-f>',
  function()
    require('telescope.builtin').find_files({
      find_command = { 'fd', '-LH', '-tf' },
    })
  end
)

map('n', '<leader>d', '<cmd> :Telescope lsp_definitions <CR>')
map('n', '<leader>i', '<cmd> :Telescope lsp_implementations <CR>')
map('n', '<leader>r', '<cmd> :Telescope lsp_references <CR>')
map('n', '<leader>t', '<cmd> :Telescope lsp_type_definitions <CR>')
map('n', '<leader>q', function()
  if vim.wo.winfixbuf then
    vim.cmd(':bdelete')
  else
    vim.cmd(':Bdelete')
  end
end)

-- 窗口
map('', '<up>', function() require('smart-splits').resize_up() end)
map('', '<down>', function() require('smart-splits').resize_down() end)
map('', '<left>', function() require('smart-splits').resize_left() end)
map('', '<right>', function() require('smart-splits').resize_right() end)
map('n', '<C-h>', function() require('smart-splits').move_cursor_left() end)
map('n', '<C-j>', function() require('smart-splits').move_cursor_down() end)
map('n', '<C-k>', function() require('smart-splits').move_cursor_up() end)
map('n', '<C-l>', function() require('smart-splits').move_cursor_right() end)
map('', 'd<up>', ':wincmd k<cr>:wincmd c<cr>:wincmd p<cr>')
map('', 'd<down>', ':wincmd j<cr>:wincmd c<cr>:wincmd p<cr>')
map('', 'd<left>', ':wincmd h<cr>:wincmd c<cr>:wincmd p<cr>')
map('', 'd<right>', ':wincmd l<cr>:wincmd c<cr>:wincmd p<cr>')

-- file explorer
map('', '<C-t>', function()
  local view = require('nvim-tree.view')
  if view.is_visible() or vim.o.buftype == 'nofile' then
    vim.cmd(':NvimTreeToggle')
  else
    vim.cmd(':NvimTreeFindFile')
  end
end)

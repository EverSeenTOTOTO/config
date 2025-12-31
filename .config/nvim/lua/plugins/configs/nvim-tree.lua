local present, file_explorer = pcall(require, 'nvim-tree')

if not present then return end

local api = require('nvim-tree.api')

file_explorer.setup({
  filters = {
    custom = {
      '\\.jpg$',
      '\\.jepg$',
      '\\.png$',
      '\\.webp$',
    },
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', 'l', function()
      local node = api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- expand or collapse folder
        api.node.open.edit()
      else
        -- open file
        api.node.open.vertical()
      end
    end, {
      buffer = bufnr,
    })
    vim.keymap.set('n', 'h', function()
      local node = api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- collapse folder
        api.node.navigate.parent_close()
      else
        -- go to parent folder
        api.node.navigate.parent()
      end
    end, {
      buffer = bufnr,
    })
    vim.keymap.set('n', 'ss', function()
      local node = api.tree.get_node_under_cursor()

      return require('grug-far').open({ prefills = { flags = '-.', paths = node.absolute_path } })
    end, {
      buffer = bufnr,
      desc = 'Advanced search',
    })
    vim.keymap.set('n', '<C-s>', function()
      local node = api.tree.get_node_under_cursor()
      local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false

      if not is_folder then
        vim.notify('Not a folder')
        return
      end

      local relpath = vim.fs.relpath(vim.fn.getcwd(), node.absolute_path)

      return require('telescope.builtin').live_grep({
        cwd = node.absolute_path,
        search_dirs = { node.absolute_path },
        prompt_title = 'Live Grep in ' .. relpath,
      })
    end, {
      buffer = bufnr,
    })
    vim.keymap.set('n', '//', function()
      local node = api.tree.get_node_under_cursor()
      local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false

      if is_folder then
        vim.notify('Not a file')
        return
      end

      local relpath = vim.fs.relpath(vim.fn.getcwd(), node.absolute_path)

      return require('telescope.builtin').live_grep({
        search_dirs = { node.absolute_path },
        prompt_title = 'Current Buffer Fuzzy in ' .. relpath,
      })
    end, {
      buffer = bufnr,
    })
  end,
})

-- restore window size when openning nvim-tree
vim.api.nvim_create_autocmd('WinResized', {
  pattern = '*',
  callback = function()
    local winid = api.tree.winid()
    if winid ~= nil and vim.tbl_contains(vim.v.event['windows'], winid) then
      vim.t['filetree_width'] = vim.api.nvim_win_get_width(winid)
    end
  end,
})
api.events.subscribe(api.events.Event.TreeOpen, function()
  if vim.t['filetree_width'] ~= nil then
    local winid = api.tree.winid()
    vim.api.nvim_win_set_width(winid, vim.t['filetree_width'])
  end
end)

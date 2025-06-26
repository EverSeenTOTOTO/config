local present, file_explorer = pcall(require, 'nvim-tree')

if not present then return end

local api = require('nvim-tree.api')

local function telescope_find_files()
  local ok, _ = pcall(require, 'telescope')

  if not ok then return end

  local node = api.tree.get_node_under_cursor()
  local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false

  if not is_folder then return end

  local basedir = node.absolute_path

  if node.name == '..' then basedir = require('nvim-tree.core').get_cwd() end

  return require('telescope.builtin').find_files({
    cwd = basedir,
    search_dirs = { basedir },
    prompt_title = 'Live Grep in ' .. basedir,
  })
end

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
    vim.keymap.set('n', '<C-f>', telescope_find_files, {
      buffer = bufnr,
    })
  end,
})

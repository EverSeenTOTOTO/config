local present, telescope = pcall(require, 'telescope')

if not present then return end

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local rg_args = {
  'rg',
  '--hidden',
  '--color=never',
  '--no-heading',
  '--with-filename',
  '--line-number',
  '--column',
  '--smart-case',
  '--trim',
  '--glob',
  '!\\*\\*/.git/\\*', -- avoid zsh expand
}

local entry_to_qf = function(entry)
  local text = entry.text

  if not text then
    if type(entry.value) == 'table' then
      text = entry.value.text
    else
      text = entry.value
    end
  end

  return {
    bufnr = entry.bufnr,
    filename = require('telescope.from_entry').path(entry, false, false),
    lnum = vim.F.if_nil(entry.lnum, 1),
    col = vim.F.if_nil(entry.col, 1),
    text = text,
    type = entry.qf_type,
  }
end

local entry_sorter = function(a, b)
  if a.filename ~= b.filename then return a.filename < b.filename end
  if a.lnum ~= b.lnum then return a.lnum < b.lnum end
  return a.col < b.col
end

local send_selected_to_qf = function(prompt_bufnr, mode)
  local picker = action_state.get_current_picker(prompt_bufnr)

  local qf_entries = {}
  for _, entry in ipairs(picker:get_multi_selection()) do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  table.sort(qf_entries, entry_sorter)

  local prompt = picker:_get_prompt()
  actions.close(prompt_bufnr)

  vim.api.nvim_exec_autocmds('QuickFixCmdPre', {})
  local qf_title = string.format([[%s (%s)]], picker.prompt_title, prompt)
  vim.fn.setqflist(qf_entries, mode)
  vim.fn.setqflist({}, 'a', { title = qf_title })
  vim.api.nvim_exec_autocmds('QuickFixCmdPost', {})
end

local send_all_to_qf = function(prompt_bufnr, mode)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local manager = picker.manager

  local qf_entries = {}
  for entry in manager:iter() do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  table.sort(
    qf_entries,
    function(a, b) return a.filename < b.filename or (a.filename == b.filename and a.lnum < b.lnum) end
  )

  local prompt = picker:_get_prompt()
  actions.close(prompt_bufnr)

  vim.api.nvim_exec_autocmds('QuickFixCmdPre', {})
  local qf_title = string.format([[%s (%s)]], picker.prompt_title, prompt)
  vim.fn.setqflist(qf_entries, mode)
  vim.fn.setqflist({}, 'a', { title = qf_title })
  vim.api.nvim_exec_autocmds('QuickFixCmdPost', {})
end

local options = {
  defaults = {
    preview = {
      filesize_limit = 1, -- MB
      treesitter = false,
    },
    default_mappings = {
      i = {
        ['<LeftMouse>'] = {
          actions.mouse_click,
          type = 'action',
          opts = { expr = true },
        },
        ['<2-LeftMouse>'] = {
          actions.double_mouse_click,
          type = 'action',
          opts = { expr = true },
        },
        ['<esc>'] = actions.close,
        ['<leader>q'] = actions.close,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<CR>'] = actions.select_default,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,
        ['<C-u>'] = actions.results_scrolling_up,
        ['<C-d>'] = actions.results_scrolling_down,
        ['<C-r><C-h>'] = actions.results_scrolling_left,
        ['<C-r><C-l>'] = actions.results_scrolling_right,
        ['<C-r><C-u>'] = actions.preview_scrolling_up,
        ['<C-r><C-d>'] = actions.preview_scrolling_down,
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['œ'] = actions.send_selected_to_qflist + actions.open_qflist, -- mac keyboard alt+q
        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key,
        ['<C-w>'] = { '<c-s-w>', type = 'command' },
      },
      n = {
        ['<LeftMouse>'] = {
          actions.mouse_click,
          type = 'action',
          opts = { expr = true },
        },
        ['<2-LeftMouse>'] = {
          actions.double_mouse_click,
          type = 'action',
          opts = { expr = true },
        },
        ['vv'] = actions.close,
        ['<esc>'] = actions.close,
        ['<leader>q'] = actions.close,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
        ['gg'] = actions.move_to_top,
        ['G'] = actions.move_to_bottom,
        ['<CR>'] = actions.select_default,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,
        ['<C-u>'] = actions.results_scrolling_up,
        ['<C-d>'] = actions.results_scrolling_down,
        ['<C-r><C-u>'] = actions.preview_scrolling_up,
        ['<C-r><C-d>'] = actions.preview_scrolling_down,
        ['<C-r><C-h>'] = actions.preview_scrolling_left,
        ['<C-r><C-l>'] = actions.preview_scrolling_right,
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['œ'] = actions.send_selected_to_qflist + actions.open_qflist, -- mac keyboard alt+q
        ['<C-/>'] = actions.which_key,
        ['<C-_>'] = actions.which_key,
      },
    },
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    vimgrep_arguments = rg_args,
    file_ignore_patterns = {
      '.git/',
      '.cache/',
      'dist/',
      'build/',
      'target/',
      'vendor/',
      '__pycache__/',
      '.pytest_cache/',
      '.mypy_cache/',
      '.ruff_cache/',
    },
  },
  pickers = {
    git_files = {
      hidden = true,
      show_untracked = true,
    },
    live_grep = {
      only_sort_text = true,
    },
    find_files = {
      find_command = { 'fd', '-LH', '-tf', '--strip-cwd-prefix' },
    },
  },
  extensions = {
    fzf = {},
  },
}

telescope.setup(options)

vim.ui.select = require('core.ui.select').select

local present, telescope = pcall(require, 'telescope')

if not present then return end

local actions = require('telescope.actions')

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

local function send_to_qflist(prompt_bufnr)
  local action_state = require('telescope.actions.state')
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local pattern = current_picker:_get_prompt()

  actions.smart_send_to_qflist(prompt_bufnr)

  local qf_refresh_group = vim.api.nvim_create_augroup('TelescopeQFRefresh', { clear = true })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = qf_refresh_group,
    pattern = '*',
    callback = function()
      -- redo the search with the current pattern and preserved search configuration
      local ok, lines = pcall(function()
        -- Extract search parameters from current picker
        local cmd = {}

        -- Use vimgrep_arguments from current picker or fallback to configured rg_args
        local vimgrep_args = current_picker.vimgrep_arguments or rg_args
        cmd = vim.deepcopy(vimgrep_args)

        -- Add current working directory if available
        if current_picker.cwd then
          table.insert(cmd, vim.fn.shellescape(pattern))
          table.insert(cmd, current_picker.cwd)
        else
          table.insert(cmd, vim.fn.shellescape(pattern))
        end

        local full_cmd = table.concat(cmd, ' ')

        return vim.fn.systemlist(full_cmd)
      end)

      if not ok or vim.v.shell_error ~= 0 then
        print('Error update qflist')
        return
      end

      -- Parse ripgrep output into quickfix entries
      local qf_entries = {}
      for _, line in ipairs(lines) do
        if line ~= '' then
          -- Parse format: filename:line:column:text
          local filename, lnum, col, text = line:match([[([^:]+):(%d+):(%d+):(.*)$]])
          if filename and lnum and col and text then
            table.insert(qf_entries, {
              filename = filename,
              lnum = tonumber(lnum),
              col = tonumber(col),
              text = text,
            })
          end
        end
      end

      -- Sort qf_entries by filename and lnum
      table.sort(qf_entries, function(a, b)
        if a.filename == b.filename then
          return a.lnum < b.lnum
        else
          return a.filename < b.filename
        end
      end)
      vim.api.nvim_exec_autocmds("QuickFixCmdPre", {})
      vim.fn.setqflist(qf_entries, "r")
      vim.api.nvim_exec_autocmds("QuickFixCmdPost", {})
      print('Updated qflist for "' .. pattern)
    end,
  })

  -- Open the quickfix window and get its buffer number
  vim.cmd('copen')
  vim.keymap.set('n', 'gq', function()
    vim.api.nvim_del_keymap('n', 'gq')
    vim.api.nvim_del_augroup_by_id(qf_refresh_group)
    print('Stop auto update qflist')
  end)
end

local options = {
  defaults = {
    preview = {
      filesize_limit = 1, -- MB
      treesitter = false,
    },
    default_mappings = {
      i = {
        ["<LeftMouse>"] = {
          actions.mouse_click,
          type = "action",
          opts = { expr = true },
        },
        ["<2-LeftMouse>"] = {
          actions.double_mouse_click,
          type = "action",
          opts = { expr = true },
        },
        ['<esc>'] = actions.close,
        ['<leader>q'] = actions.close,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["<CR>"] = actions.select_default,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ['<C-u>'] = actions.results_scrolling_up,
        ['<C-d>'] = actions.results_scrolling_down,
        ['<C-r><C-u>'] = actions.preview_scrolling_up,
        ['<C-r><C-d>'] = actions.preview_scrolling_down,
        ["<C-r><C-h>"] = actions.preview_scrolling_left,
        ["<C-r><C-l>"] = actions.preview_scrolling_right,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ['œ'] = actions.send_selected_to_qflist + actions.open_qflist, -- mac keyboard alt+q
        ["<C-/>"] = actions.which_key,
        ["<C-_>"] = actions.which_key,
        ["<C-w>"] = { "<c-s-w>", type = "command" },
      },
      n = {
        ["<LeftMouse>"] = {
          actions.mouse_click,
          type = "action",
          opts = { expr = true },
        },
        ["<2-LeftMouse>"] = {
          actions.double_mouse_click,
          type = "action",
          opts = { expr = true },
        },
        ['vv'] = actions.close,
        ['<esc>'] = actions.close,
        ['<leader>q'] = actions.close,
        ["<C-n>"] = actions.move_selection_next,
        ["<C-p>"] = actions.move_selection_previous,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<CR>"] = actions.select_default,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ['<C-u>'] = actions.results_scrolling_up,
        ['<C-d>'] = actions.results_scrolling_down,
        ['<C-r><C-u>'] = actions.preview_scrolling_up,
        ['<C-r><C-d>'] = actions.preview_scrolling_down,
        ["<C-r><C-h>"] = actions.preview_scrolling_left,
        ["<C-r><C-l>"] = actions.preview_scrolling_right,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ['œ'] = actions.send_selected_to_qflist + actions.open_qflist, -- mac keyboard alt+q
        ["<C-/>"] = actions.which_key,
        ["<C-_>"] = actions.which_key,
      }
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
      '.vscode/',
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
      attach_mappings = function(prompt_bufnr, map)
        -- Add <C-q> mapping to send all results to quickfix list
        map('i', '<C-q>', function() send_to_qflist(prompt_bufnr) end)
        return true
      end,
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
vim.ui.select = require('core.ui.select').select


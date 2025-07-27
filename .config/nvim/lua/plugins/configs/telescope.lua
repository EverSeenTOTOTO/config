local present, telescope = pcall(require, 'telescope')

if not present then return end

local telescope_actions = require('telescope.actions.set')
local actions = require('telescope.actions')

local rg_args = {
  'rg',
  '--hidden',
  '--color=never',
  '--no-heading',
  '--with-filename',
  '--line-number',
  '--column',
}

local options = {
  defaults = {
    preview = {
      filesize_limit = 1, -- MB
    },
    mappings = {
      i = {
        ['vv'] = actions.close,
        ['<C-u>'] = actions.results_scrolling_up,
        ['<C-d>'] = actions.results_scrolling_down,
      },
    },
    vimgrep_arguments = rg_args,
    prompt_prefix = '  ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
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
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = {
      '%.lock',
      '__pycache__/*',
      '%.sqlite3',
      '%.ipynb',
      'node_modules/*',
      '%.jpg',
      '%.jpeg',
      '%.png',
      '%.svg',
      '%.otf',
      '%.ttf',
      '.git/',
      '%.webp',
      '.dart_tool/',
      '.github/',
      '.gradle/',
      '.idea/',
      '.settings/',
      '.vscode/',
      '__pycache__/',
      'build/',
      'env/',
      'gradle/',
      'node_modules/',
      'target/',
      '%.pdb',
      '%.dll',
      '%.class',
      '%.exe',
      '%.cache',
      '%.ico',
      '%.pdf',
      '%.dylib',
      '%.jar',
      '%.docx',
      '%.met',
      'smalljre_*/*',
      '.vale/',
      '%.burp',
      '%.mp4',
      '%.mkv',
      '%.rar',
      '%.zip',
      '%.7z',
      '%.tar',
      '%.bz2',
      '%.epub',
      '%.flac',
      '%.tar.gz',
    },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = { 'truncate' },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
  },
  pickers = {
    git_files = {
      hidden = true,
      show_untracked = true,
      layout_strategy = 'horizontal',
    },
    live_grep = {
      only_sort_text = true,
      layout_strategy = 'horizontal',
      attach_mappings = function(prompt_bufnr, map)
        -- Add <C-q> mapping to send all results to quickfix list
        map('i', '<C-q>', function()
          local action_state = require('telescope.actions.state')
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          local pattern = current_picker:_get_prompt()

          actions.smart_send_to_qflist(prompt_bufnr)

          local qf_refresh_group = vim.api.nvim_create_augroup('TelescopeQFRefresh', { clear = true })

          vim.api.nvim_create_autocmd('BufWritePost', {
            group = qf_refresh_group,
            pattern = '*',
            callback = function()
              local current_idx = vim.fn.getqflist({ idx = 0 }).idx

              -- redo the search with the current pattern and preserved search configuration
              local ok, lines = pcall(function()
                -- Extract search parameters from current picker
                local cmd = {}

                -- Use vimgrep_arguments from current picker or fallback to configured rg_args
                local vimgrep_args = current_picker.vimgrep_arguments or rg_args
                cmd = vim.deepcopy(vimgrep_args)

                -- Add current working directory if available
                if current_picker.cwd then
                  table.insert(cmd, '--')
                  table.insert(cmd, vim.fn.shellescape(pattern))
                  table.insert(cmd, current_picker.cwd)
                else
                  table.insert(cmd, vim.fn.shellescape(pattern))
                end

                local full_cmd = table.concat(cmd, ' ')

                return vim.fn.systemlist(full_cmd)
              end)

              if not ok or vim.v.shell_error ~= 0 then
                vim.notify('Error refreshing qflist: ' .. (lines or 'unknown error'), vim.log.levels.ERROR, {
                  title = 'Telescope QF Refresh',
                })
                return
              end

              -- Parse ripgrep output into quickfix entries
              local qf_entries = {}
              for _, line in ipairs(lines) do
                if line ~= '' then
                  -- Parse format: filename:line:column:text
                  local filename, lnum, col, text = line:match('([^:]+):(%d+):(%d+):(.*)$')
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

              -- Check if we have any search results
              vim.fn.setqflist(qf_entries)

              vim.notify('Qflist for "' .. pattern .. ' updated', vim.log.levels.INFO, {
                title = 'Telescope QF Refresh',
              })

              if current_idx <= #qf_entries then vim.fn.setqflist({}, 'a', { idx = current_idx }) end
            end,
          })

          vim.api.nvim_create_autocmd('QuitPre', {
            group = qf_refresh_group,
            callback = function()
              if vim.bo.filetype == 'qf' then
                vim.api.nvim_del_augroup_by_name('TelescopeQFRefresh')
                vim.notify('Stop auto update qflist', vim.log.levels.INFO, {
                  title = 'Telescope QF Refresh',
                })
              end
            end,
            once = true,
          })

          vim.cmd('copen')
        end)
        return true
      end,
    },
    find_files = {
      layout_strategy = 'horizontal',
      attach_mappings = function(_)
        telescope_actions.select:enhance({
          post = function() vim.cmd(':normal! zx') end,
        })
        return true
      end,
      find_command = { 'fd', '-LH', '-tf' },
    },
  },
  extensions = {
    fzf = {},
  },
}

telescope.setup(options)

vim.ui.select = require('core.ui.select').select

local present, avante = pcall(require, 'avante')
if not present then return end

-- Get environment variables once
local api_base = vim.uv.os_getenv('OPENAI_API_BASE')
local api_key = vim.uv.os_getenv('OPENAI_API_KEY')
local serp_api_key = vim.uv.os_getenv('SERP_API_KEY')

-- Validate required environment variables
if not api_base or not api_key then
  vim.notify('Please set OPENAI_API_BASE and OPENAI_API_KEY environment variables', vim.log.levels.ERROR)
  return
end

if not serp_api_key then
  vim.notify('Please set SERP_API_KEY environment variable for web search', vim.log.levels.WARN)
end

avante.setup({
  system_prompt = function()
    local hub = require('mcphub').get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ''
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require('mcphub.extensions.avante').mcp_tool(),
    }
  end,
  disabled_tools = {
    'list_files', -- Built-in file operations
    'search_files',
    'read_file',
    'create_file',
    'rename_file',
    'delete_file',
    'create_dir',
    'rename_dir',
    'delete_dir',
    'bash', -- Built-in terminal access
  },

  provider = 'proxy-claude',
  providers = {
    copilot = {
      model = 'gpt-4.1',
    },

    ['proxy-claude'] = {
      __inherited_from = 'openai',
      endpoint = api_base,
      api_key_name = 'OPENAI_API_KEY',
      model = 'claude-3-7-sonnet-latest',
    },

    openai = {
      endpoint = api_base,
      model = 'gpt-4o',
      timeout = 30000,
      extra_request_body = {
        temperature = 0.7,
        max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
        reasoning_effort = 'medium', -- low|medium|high, only used for reasoning models
      },
    },
  },

  web_search_engine = {
    provider = 'serpapi',
    serpapi = {
      api_key_name = serp_api_key,
    },
  },

  mappings = {
    diff = {},
    suggestions = {},
    jump = {},
    submit = {
      insert = '<C-l>',
    },
    cancel = {
      normal = { '<C-c>' },
      insert = { '<C-c>' },
    },
    new_ask = '<space>a',
    ask = '<space><space>',
    edit = '<space>e',
    refresh = '<space>r',
    focus = '<space>f',
    stop = '<space>s',
    select_model = '<space>m',
    toggle = {},
    sidebar = {
      close = { '<Esc>', '<space><space>' },
    },
    files = {
      add_all_buffers = '<leader>ab',
    },
  },
  file_selector = {
    provider = 'telescope',
    provider_opts = {
      get_filepaths = function(params)
        local plenary_scan = require('plenary.scandir')
        local project_root = params.cwd or vim.fn.getcwd()

        -- Use plenary's scan_dir to get all files including hidden ones
        -- Get telescope ignore patterns to ensure consistency
        local telescope_ignore_patterns = require('telescope.config').values.file_ignore_patterns or {}

        local all_files = plenary_scan.scan_dir(project_root, {
          hidden = true,
          depth = 10,
          respect_gitignore = true,
          on_insert = function(entry)
            -- Check against telescope ignore patterns
            for _, pattern in ipairs(telescope_ignore_patterns) do
              if entry:match(pattern) then return false end
            end

            return true
          end,
        })

        return vim.tbl_filter(
          function(filepath) return not vim.tbl_contains(params.selected_filepaths, filepath) end,
          all_files
        )
      end,
    },
  },
  behaviour = {},
  windows = {
    width = 40,
    ask = {
      start_insert = false,
    },
  },
})

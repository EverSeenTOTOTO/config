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

  provider = 'copilot',
  providers = {
    copilot = {
      model = 'claude-3.7-sonnet',
    },

    ['proxy-claude'] = {
      __inherited_from = 'openai',
      endpoint = api_base,
      api_key_name = 'OPENAI_API_KEY',
      model = 'claude-3-7-sonnet-latest',
    },

    ['proxy-gemmi'] = {
      __inherited_from = 'openai',
      endpoint = api_base,
      api_key_name = 'OPENAI_API_KEY',
      model = 'gemini-2.5-pro-preview-06-05',
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
    diff = {
      next = '<leader>]',
      prev = '<leader>[',
    },
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
  },
  behaviour = {},
  windows = {
    width = 40,
  },
})

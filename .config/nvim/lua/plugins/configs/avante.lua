local present, avante = pcall(require, 'avante')

local api_base = vim.uv.os_getenv('OPENAI_API_BASE')
local api_key = vim.uv.os_getenv('OPENAI_API_KEY')
local serp_api_key = vim.uv.os_getenv('SERP_API_KEY')

if not present then return end

if not api_base or not api_key then
  vim.notify('Please set OPENAI_API_BASE and OPENAI_API_KEY environment variables', vim.log.levels.ERROR)
  return
end

avante.setup({
  provider = 'copilot',
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

  -- openai = {
  --   endpoint = api_base,
  --   model = "gpt-4o",
  --   max_tokens = 16384,
  --   reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  -- },
  copilot = {
    endpoint = 'https://api.githubcopilot.com',
    model = 'gpt-4o',
  },
  web_search_engine = {
    provider = 'searpapi',
    searpapi = {
      api_key_name = serp_api_key,
    },
  },
  mappings = {
    diff = {
      next = '<leader>]',
      prev = '<leader>[',
    },
    submit = {
      insert = '<C-l>',
    },
    cancel = {
      normal = { '<C-c>' },
      insert = { '<C-c>' },
    },
    ask = '<space><space>',
    edit = '<space>e',
    sidebar = {
      close = { '<Esc>', '<space><space>' },
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

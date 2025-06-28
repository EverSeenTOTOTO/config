vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
})

require('lspkind').setup({
  symbol_map = {
    Text = '󰉿',
    Method = '󰆧',
    Function = '󰊕',
    Constructor = '',
    Field = '󰜢',
    Variable = '󰀫',
    Class = '󰠱',
    Interface = '',
    Module = '',
    Property = '󰜢',
    Unit = '󰑭',
    Value = '󰎠',
    Enum = '',
    Keyword = '󰌋',
    Snippet = '',
    Color = '󰏘',
    File = '󰈙',
    Reference = '󰈇',
    Folder = '󰉋',
    EnumMember = '',
    Constant = '󰏿',
    Struct = '󰙅',
    Event = '',
    Operator = '󰆕',
    TypeParameter = '',
  },
})

local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

-- LSP
local setup = function(name, opts)
  local options = {
    capabilities = capabilities,
  }

  if opts then options = vim.tbl_extend('force', options, opts) end

  vim.lsp.config(name, options)
  vim.lsp.enable(name)
end

-- biome
setup('biome', {
  filetypes = {
    'astro',
    'graphql',
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
  },
})

-- cpp
setup('clangd')

-- cmake
setup('cmake')

-- eslint
setup('eslint')

-- html
setup('html')

-- lua
setup('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'Lua 5.1',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- rust

-- stylelint
setup('stylelint_lsp', {
  filetypes = { 'css', 'less', 'scss', 'sugarss', 'vue', 'wxss' },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
})

-- tsserver
local bun_root = vim.fn.system('echo $BUN_INSTALL', nil):gsub('^%s*(.-)%s*$', '%1') .. '/install/global'

if not bun_root or bun_root == '' then
  vim.notify('No bun root found', vim.log.levels.ERROR)
  return
end

-- typescript
setup('vtsls', {
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
  },
  settings = {
    typescript = {
      updateImportsOnFileMove = 'always',
    },
    javascript = {
      updateImportsOnFileMove = 'always',
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = bun_root .. '/@vue/language-server',
            languages = { 'vue' },
            configNamespace = 'typescript',
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
})

-- vue
setup('vue_ls', {
  init_options = {
    typescript = {
      tsdk = bun_root .. '/typescript/lib',
    },
  },
  before_init = function(_, config)
    local lib_path = vim.fs.find('node_modules/typescript/lib', { path = config.root_dir, upward = true })[1]
    if lib_path then config.init_options.typescript.tsdk = lib_path end
  end,
})

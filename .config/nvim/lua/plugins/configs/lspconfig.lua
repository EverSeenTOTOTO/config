local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn",  text = "" },
  { name = "DiagnosticSignHint",  text = "" },
  { name = "DiagnosticSignInfo",  text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = { active = signs },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- LSP
local setup = function(name, opts)
  local options = {}

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  lspconfig[name].setup(options)
end

-- cpp
setup("clangd")

-- cmake
setup("cmake")

-- eslint
setup("eslint", {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- html
setup("html")

-- json
setup("jsonls")

-- lua
setup("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "Lua 5.1",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
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
setup("stylelint_lsp", {
  filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
})

setup("svelte")

-- tsserver
-- vue
setup("volar", {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
})

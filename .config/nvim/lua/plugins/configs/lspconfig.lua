local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
  signs = { active = signs },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

local M = {}

function M.on_attach(client)
  client.server_capabilities.document_formatting = false
  client.server_capabilities.document_range_formatting = false

  if client.server_capabilities.document_highlight then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- LSP
local setupLSP = function(name, opts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local options = {
    on_attach = M.on_attach,
    capabilities = capabilities,
  }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  lspconfig[name].setup(options)
end

-- cpp
setupLSP("clangd")

-- cmake
setupLSP("cmake")

-- eslint
setupLSP("eslint")

-- html
setupLSP("html")

-- json
setupLSP("jsonls")

-- lua
setupLSP("sumneko_lua", {
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

-- stylelint
setupLSP("stylelint_lsp", {
  filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true,
    },
  },
})

-- tsserver
setupLSP("tsserver")

-- vue
setupLSP("vuels")

return M

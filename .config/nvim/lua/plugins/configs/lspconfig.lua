local present, lspconfig = pcall(require, "lspconfig")

if not present then
  return
end

local M = {}

require "plugins.configs.lsp_handlers"

function M.on_attach(client, bufnr)
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

  require("core.mappings").lspconfig()
end

-- LSP
local setupLSP = function(name, opts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
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

-- bash
setupLSP "bashls"

-- cpp
setupLSP "clangd"

-- cmake
setupLSP "cmake"

-- css
setupLSP "cssls"

-- eslint
setupLSP "eslint"

-- html
setupLSP "html"

-- json
setupLSP "jsonls"

-- lua
setupLSP("sumneko_lua", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

-- rust
setupLSP("rust_analyzer", {
  cargo = {
    loadOutDirsFromCheck = true,
  },
  checkOnSave = {
    command = "clippy",
  },
  experimental = {
    procAttrMacros = true,
  },
})

-- stylelint
setupLSP("stylelint_lsp", {
  filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = true
    }
  }
})

-- svelte
setupLSP "svelte"

-- tsserver
setupLSP "tsserver"

-- vue
setupLSP "vuels"

-- vim
setupLSP "vimls"

return M

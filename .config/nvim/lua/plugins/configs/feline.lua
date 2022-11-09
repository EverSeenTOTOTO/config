local status_ok, feline = pcall(require, "feline")
if status_ok then
  local C = require "core.colors"
  local hl = require("plugins.configs.status").hl
  local provider = require("plugins.configs.status").provider
  local conditional = require("plugins.configs.status").conditional

  feline.setup({
    disable = { filetypes = { "^NvimTree$", "^neo%-tree$", "^dashboard$", "^Outline$", "^aerial$" } },
    components = {
      active = {
        {
          { provider = provider.mode, hl = hl.mode() },
          { provider = provider.spacer(2) },
          { provider = "git_branch", hl = hl.fg("Conditional", { fg = C.purple_1, style = "bold" }), icon = " " },
          { provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } }, enabled = conditional.has_filetype },
          { provider = provider.spacer(2), enabled = conditional.has_filetype },
          { provider = "diagnostic_errors", hl = hl.fg("DiagnosticError", { fg = C.red_1 }), icon = "  " },
          { provider = "diagnostic_warnings", hl = hl.fg("DiagnosticWarn", { fg = C.orange_1 }), icon = "  " },
          { provider = "diagnostic_info", hl = hl.fg("DiagnosticInfo", { fg = C.white_2 }), icon = "  " },
          { provider = "diagnostic_hints", hl = hl.fg("DiagnosticHint", { fg = C.yellow_1 }), icon = "  " },
        },
        {
          { provider = provider.lsp_progress, enabled = conditional.bar_width() },
          { provider = provider.lsp_client_names(), short_provider = provider.lsp_client_names(), enabled = conditional.bar_width(), icon = "   " },
          { provider = provider.spacer(2) },
          { provider = "position" },
          { provider = provider.spacer(2) },
          { provider = "line_percentage" },
        },
      },
    },
  })
end

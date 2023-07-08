local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

local options = {
  options = {
    always_show_bufferline = true,
    buffer_close_icon = "",
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    hover = { enabled = true, reveal = { "close" } },
    indicator = { style = "icon", icon = "▎" },
    show_buffer_close_icons = true,
    enforce_regular_tabs = false,
    max_name_length = 18,
    max_prefix_length = 15,
    modified_icon = "",
    separator_style = "thin",
    show_close_icon = false,
    show_tab_indicators = true,
    tab_size = 18,
    color_icons = true,
    style_preset = bufferline.style_preset.no_italic,
    offsets = {
      {
        filetype = "NvimTree",
        text = " File Explorer",
        text_align = "left",
        highlight = "Directory",
        separator = true -- use a "true" to enable the default, or set your own character
      }
    }
  },
}

bufferline.setup(options)

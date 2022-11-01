local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

local g_ok, bufferline_groups = pcall(require, "bufferline.groups")
if not g_ok then
  bufferline_groups = {
    builtin = {
      pinned = {
        name = "pinned",
        with = function(_ico)
        end,
      },
      ungroupued = { name = "ungrouped" },
    },
  }
end
local colors = require "core.colors"
local kind = require "plugins.configs.lspkind_icons"

local options = {
  options = {
    always_show_bufferline = true,
    buffer_close_icon = "",
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    enforce_regular_tabs = false,
    hover = { enabled = true, reveal = { "close" } },
    left_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    modified_icon = "",
    offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
    right_trunc_marker = "",
    separator_style = "thin",
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    tab_size = 18,
    view = "multiwindow",
    groups = {
      options = {
        toggle_hidden_on_enter = true,
      },
      items = {
        bufferline_groups.builtin.pinned:with { icon = "" },
        bufferline_groups.builtin.ungrouped,
        {
          highlight = { sp = "#51AFEF" },
          name = "tests",
          icon = kind.icons.test,
          matcher = function(buf)
            local name = buf.filename
            return name:match "spec" or name:match "test"
          end,
        },
        {
          highlight = { sp = "#C678DD" },
          name = "docs",
          matcher = function(buf)
            for _, ext in ipairs { "md", "txt", "org", "norg", "wiki" } do
              if ext == vim.fn.fnamemodify(buf.path, ":e") then
                return true
              end
            end
          end,
        },
        {
          highlight = { sp = "#F6A878" },
          name = "config",
          matcher = function(buf)
            local filename = buf.filename
            if filename == nil then
              return false
            end
            return filename:match "go.mod"
              or filename:match "go.sum"
              or filename:match "Cargo.toml"
              or filename:match "manage.py"
              or filename:match "Makefile"
          end,
        },
      },
    },
  },

  highlights = {
    background = {
      fg = colors.grey_fg,
      bg = colors.black2,
    },

    -- buffers
    buffer_selected = {
      fg = colors.white,
      bg = colors.black,
    },
    buffer_visible = {
      fg = colors.light_grey,
      bg = colors.black2,
    },

    -- for diagnostics = "nvim_lsp"
    error = {
      fg = colors.light_grey,
      bg = colors.black2,
    },
    error_diagnostic = {
      fg = colors.light_grey,
      bg = colors.black2,
    },

    -- close buttons
    close_button = {
      fg = colors.light_grey,
      bg = colors.black2,
    },
    close_button_visible = {
      fg = colors.light_grey,
      bg = colors.black2,
    },
    close_button_selected = {
      fg = colors.red,
      bg = colors.black,
    },
    fill = {
      fg = colors.grey_fg,
      bg = colors.black2,
    },
    indicator_selected = {
      fg = colors.black,
      bg = colors.black,
    },

    -- modified
    modified = {
      fg = colors.red,
      bg = colors.black2,
    },
    modified_visible = {
      fg = colors.red,
      bg = colors.black2,
    },
    modified_selected = {
      fg = colors.green,
      bg = colors.black,
    },

    -- separators
    separator = {
      fg = colors.black2,
      bg = colors.black2,
    },
    separator_visible = {
      fg = colors.black2,
      bg = colors.black2,
    },
    separator_selected = {
      fg = colors.black2,
      bg = colors.black2,
    },

    -- tabs
    tab = {
      fg = colors.light_grey,
      bg = colors.one_bg3,
    },
    tab_selected = {
      fg = colors.black2,
      bg = colors.nord_blue,
    },
    tab_close = {
      fg = colors.red,
      bg = colors.black,
    },
  },
}

bufferline.setup(options)

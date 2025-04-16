local present, colorizer = pcall(require, 'colorizer')

if not present then return end

local options = {
  filetypes = {
    '*',
  },
  user_default_options = {
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn

    -- Available modes: foreground, background
    mode = 'background', -- Set the display mode.
  },
}

colorizer.setup(options['filetypes'], options['user_default_options'])
vim.cmd('ColorizerReloadAllBuffers')

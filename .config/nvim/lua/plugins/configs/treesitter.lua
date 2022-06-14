local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
  return
end

local options = {
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "json5",
    "llvm",
    "lua",
    "make",
    "markdown",
    "python",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  },
  sync_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  rainbow = {
    enable = true,
    disable = { "html" },
    extended_mode = false,
    max_file_lines = nil,
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = false },
}

treesitter.setup(options)

local present, file_explorer = pcall(require, "nvim-tree")

if not present then
  return
end

file_explorer.setup({
  filters = {
    custom = {
      "\\.jpg$",
      "\\.jepg$",
      "\\.png$",
      "\\.webp$"
    }
  }
})

local present, packer = pcall(require, "packer")

if not present then
  local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

  print "Cloning packer.."
  -- remove the dir before cloning
  vim.fn.delete(packer_path, "rf")
  vim.fn.system {
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    "--depth",
    "1",
    packer_path,
  }

  present, packer = pcall(require, "packer")

  if not present then
    vim.api.nvim_err_writeln("Failed to load packer at:" .. packer_path .. "\n\n" .. packer)
  end
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
    prompt_border = "single",
  },
  git = {
    clone_timeout = 6000, -- seconds
  },
  auto_clean = true,
  compile_on_sync = true,
}

return packer

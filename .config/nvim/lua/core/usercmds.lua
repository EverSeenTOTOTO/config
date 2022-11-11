local user_cmd = vim.api.nvim_create_user_command

-- Add Packer commands because we are not loading it at startup

local packer_cmd = function(callback)
	return function()
		require("plugins")
		require("packer")[callback]()
	end
end

user_cmd("PackerClean", packer_cmd("clean"), {})
user_cmd("PackerInstall", packer_cmd("install"), {})
user_cmd("PackerStatus", packer_cmd("status"), {})
user_cmd("PackerSync", packer_cmd("sync"), {})
user_cmd("PackerUpdate", packer_cmd("update"), {})

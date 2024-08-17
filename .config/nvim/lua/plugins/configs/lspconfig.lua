local present, lspconfig = pcall(require, "lspconfig")

if not present then
	return
end

local util = require("lspconfig.util")

vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
	severity_sort = true,
	underline = true,
	update_in_insert = false,
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

-- LSP
local setup = function(name, opts)
	local options = {
		capabilities = capabilities,
	}

	if opts then
		options = vim.tbl_extend("force", options, opts)
	end

	lspconfig[name].setup(options)
end

-- cpp
setup("clangd")

-- cmake
setup("cmake")

-- eslint
setup("eslint")

-- html
setup("html")

-- json
setup("jsonls")

-- lua
setup("lua_ls", {
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

-- rust

-- stylelint
setup("stylelint_lsp", {
	filetypes = { "css", "less", "scss", "sugarss", "vue", "wxss" },
	settings = {
		stylelintplus = {
			autoFixOnFormat = true,
		},
	},
})

setup("svelte")

-- tsserver
local npm_root = vim.fn.system("npm root -g", nil):gsub("^%s*(.-)%s*$", "%1")

if not npm_root or npm_root == "" then
	vim.notify("No npm root found", vim.log.levels.ERROR)
	return
end

local function get_typescript_server_path(root_dir)
	local global_ts = npm_root .. "/typescript/lib"
	local found_ts = ""
	local function check_dir(path)
		found_ts = util.path.join(path, "node_modules", "typescript", "lib")
		if util.path.exists(found_ts) then
			return path
		end
	end
	if util.search_ancestors(root_dir, check_dir) then
		return found_ts
	else
		return global_ts
	end
end

-- typescript
setup("vtsls", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	settings = {
		typescript = {
			updateImportsOnFileMove = "always",
		},
		javascript = {
			updateImportsOnFileMove = "always",
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = npm_root .. "/@vue/typescript-plugin",
						languages = { "javascript", "typescript", "vue" },
					},
				},
			},
		},
	},
})

-- vue
setup("volar", {
	on_new_config = function(new_config, new_root_dir)
		new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
	end,
})

local present, avante = pcall(require, "avante")

local api_base = vim.uv.os_getenv("OPENAI_API_BASE")
local api_key = vim.uv.os_getenv("OPENAI_API_KEY")
local serp_api_key = vim.uv.os_getenv("SERP_API_KEY")

if not present then
	return
end

if not api_base or not api_key then
	vim.notify("Please set OPENAI_API_BASE and OPENAI_API_KEY environment variables", vim.log.levels.ERROR)
	return
end

avante.setup({
	provider = "copilot",
	-- openai = {
	--   endpoint = api_base,
	--   model = "gpt-4o",
	--   max_tokens = 16384,
	--   reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
	-- },
	copilot = {
		endpoint = "https://api.githubcopilot.com",
		model = "gpt-4o-2024-08-06",
		proxy = nil, -- [protocol://]host[:port] Use this proxy
		max_tokens = 20480,
	},
	web_search_engine = {
		provider = "searpapi",
		searpapi = {
			api_key_name = serp_api_key,
		},
	},
	mappings = {
		diff = {
			next = "<leader>]",
			prev = "<leader>[",
		},
		submit = {
			insert = "<C-i>",
		},
		cancel = {
			normal = { "vv", "<Esc>", "q" },
			insert = { "vv" },
		},
		ask = "<space><space>",
		edit = "<space>e",
	},
	file_selector = {
		provider = "telescope",
	},
	windows = {
		width = 40,
	},
})

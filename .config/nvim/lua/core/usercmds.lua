local create_usercmd = vim.api.nvim_create_user_command

create_usercmd("TsOrgnizeImports", function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if client.name == "vtsls" then
			client:request("workspace/executeCommand", {
				command = "typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "",
			})
		end
	end
end, {})

local function get_selection_or_cursor_range()
	-- 获取选区的开始和结束位置
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

	-- Neovim 的行和列索引从 0 开始，但 Vim 的 getpos 函数返回的索引从 1 开始
	start_line = start_line - 1
	start_col = start_col - 1
	end_line = end_line - 1
	end_col = end_col - 1

	-- 如果 start_line 大于 end_line，那么交换它们的值
	if start_line > end_line or (start_line == end_line and start_col > end_col) then
		start_line, end_line = end_line, start_line
		start_col, end_col = end_col, start_col
	end

	local line_count = vim.api.nvim_buf_line_count(0)
	if end_line + 1 > line_count then
		end_line = line_count - 1
	end

	return { start_line, start_col, end_line, end_col }
end

local function get_selection()
	local range = get_selection_or_cursor_range()
	local start_line, _, end_line, _ = unpack(range)

	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)

	return table.concat(lines)
end

local function replace_selection(new_content)
	-- 获取选区或光标的位置
	local range = get_selection_or_cursor_range()
	local start_line, _, end_line, _ = unpack(range)

	-- 获取当前缓冲区
	local buf = vim.api.nvim_get_current_buf()

	-- 删除选区的内容，如果没有选区，这个操作不会有任何效果
	vim.api.nvim_buf_set_lines(buf, start_line, end_line + 1, false, {})

	-- 插入新的内容
	local lines = {}
	for s in new_content:gmatch("[^\r\n]+") do
		table.insert(lines, s)
	end
	vim.api.nvim_buf_set_lines(buf, start_line, start_line, false, lines)
end

create_usercmd("SplitCurrentLine", function()
	vim.ui.input({
		prompt = "Seperator: ",
		default = " ",
	}, function(sep)
		local buf = vim.api.nvim_get_current_buf()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
		local lines = vim.split(line, sep:gsub("^%s*(.-)%s*$", "%1"):gsub("^$", " "), {
			plain = true,
			trimempty = true,
		})

		vim.api.nvim_buf_set_lines(buf, row - 1, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row, col })
	end)
end, {})

create_usercmd("Chat", function()
	local apiKey = vim.fn.getenv("OPENAI_API_KEY")
	local apiBase = vim.fn.getenv("OPENAI_API_BASE")

	if not apiKey or not apiBase then
		vim.notify("Please set OPENAI_API_KEY and OPEN_API_BASE", vim.log.levels.ERROR, {})
	end

	vim.ui.input({ prompt = "Prompt: " }, function(prompt)
		local Job = require("plenary.job")
		local url = apiBase .. "/chat/completions"
		local selection = get_selection()

		local param = {
			model = "gpt-4",
			messages = {
				{
					role = "system",
					content = "你是一个 AI 编程助手。无论用户给了什么prompt，你始终应该仅输出代码内容，不要做解释。",
				},
				{
					role = "user",
					content = string.format("%s\n```\n%s\n```", prompt, selection),
				},
			},
			temperature = 0.7,
		}
		local data = vim.fn.json_encode(param)
		local spin = require("core.spin")()

		spin.start("Fetching...")

		Job:new({
			command = "curl",
			args = {
				"-s",
				"-X",
				"POST",
				"-H",
				"Content-Type: application/json",
				"-H",
				string.format("Authorization: Bearer %s", apiKey),
				"-d",
				data,
				url,
			},
			on_stdout = function(e, result)
				if e then
					vim.notify(vim.inspect(e), vim.log.levels.ERROR, {})
					spin.stop()
					return
				end

				spin.update("Parsing...")

				vim.schedule(function()
					local ok, rsp = pcall(vim.fn.json_decode, result)

					if not ok then
						vim.notify(string.format("Json parse error: %s", result), vim.log.levels.ERROR, {})
						spin.stop()
						return
					end

					if rsp.error then
						vim.notify(string.format("Response error: %s", rsp.error.message), vim.log.levels.ERROR, {})
						spin.stop()
						return
					end

					spin.stop()

					local content = rsp.choices[1].message.content

					replace_selection(content)
				end)
			end,
			on_stderr = function(error, result)
				spin.stop()
				if error or result then
					vim.notify(
						string.format("Request error: %s", vim.inspect(error or result)),
						vim.log.levels.ERROR,
						{}
					)
				end
			end,
		}):start()
	end)
end, {})

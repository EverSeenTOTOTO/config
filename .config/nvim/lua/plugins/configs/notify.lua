local status_ok, notify = pcall(require, "notify")

if status_ok then
	local max_width = 60

	notify.setup({
		max_width = max_width,
		fps = 60,
		timeout = 4000,
		stages = "slide",
	})

	local function split_length(text, length)
		local lines = {}
		local next_line
		while true do
			if #text == 0 then
				return lines
			end
			next_line, text = text:sub(1, length), text:sub(length)
			lines[#lines + 1] = next_line
		end
	end

	vim.notify = function(msg, level, opts)
		if type(msg) == "string" then
			msg = vim.split(msg, "\n")
		end
		local truncated = {}
		for i, line in ipairs(msg) do
			local new_lines = split_length(line, max_width)
			for _, l in ipairs(new_lines) do
				truncated[#truncated + 1] = l
			end
		end
		return require("notify")(truncated, level, opts)
	end
end

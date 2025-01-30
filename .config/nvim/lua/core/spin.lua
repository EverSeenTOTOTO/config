return function()
	local chars = { "-", "\\", "|", "/" }
	local timer_id = nil
	local idx = 1
	local loading_text = "Loading"

	local function loading_animation()
		if idx > #chars then
			idx = 1
		end
		vim.api.nvim_echo({ { loading_text .. " " .. chars[idx], "Question" } }, true, {})
		vim.cmd("redraw")
		idx = idx + 1
	end

	local function start(text)
		loading_text = text or "Loading"
		timer_id = vim.loop.new_timer()
		timer_id:start(0, 100, vim.schedule_wrap(loading_animation))
	end

	local function stop()
		if timer_id then
			timer_id:stop()
			timer_id:close()
			timer_id = nil
			vim.api.nvim_echo({ "" }, true, {})
		end
	end

	return {
		start = start,
		stop = stop,
		update = function(text)
			loading_text = text
		end,
	}
end

-- SOLUTION WITHOUT COLOR
-- local api = vim.api
-- local orig_buf = api.nvim_get_current_buf()
-- local term_buf = api.nvim_create_buf(false, true)
-- api.nvim_set_current_buf(term_buf)
-- vim.bo.scrollback = 100000
-- local term_chan = api.nvim_open_term(0, {})
-- api.nvim_chan_send(term_chan, table.concat(api.nvim_buf_get_lines(orig_buf, 0, -1, true), "\r\n"))
-- vim.fn.chanclose(term_chan)
-- api.nvim_buf_set_lines(orig_buf, 0, -1, true, api.nvim_buf_get_lines(term_buf, 0, -1, true))
-- api.nvim_set_current_buf(orig_buf)
-- api.nvim_buf_delete(term_buf, { force = true })
-- vim.bo.modified = false
-- api.nvim_win_set_cursor(0, { api.nvim_buf_line_count(0), 0 })

-- SOLUTION WITH COLOR
local api = vim.api

local function colorize()
	-- Get current buffer and its content
	local orig_buf = api.nvim_get_current_buf()
	local lines = api.nvim_buf_get_lines(orig_buf, 0, -1, false)

	-- Trim trailing empty lines
	while #lines > 0 and vim.trim(lines[#lines]) == "" do
		table.remove(lines)
	end

	-- Create a terminal buffer
	local buf = api.nvim_create_buf(false, true)
	local chan = api.nvim_open_term(buf, {})

	-- Send lines to terminal
	api.nvim_chan_send(chan, table.concat(lines, "\r\n"))

	-- Switch to terminal buffer
	api.nvim_set_current_buf(buf)

	-- Disable UI clutter
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.statuscolumn = ""
	vim.wo.signcolumn = "no"

	-- Allow easy exit
	vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
	api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })

	-- Automatically enter insert mode briefly to draw ANSI codes
	vim.defer_fn(function()
		vim.cmd.startinsert()
	end, 10)
end

colorize()

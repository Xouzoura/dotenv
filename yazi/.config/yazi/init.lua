-- function Linemode:mtimev2()
-- 	-- does not work with directories
-- 	local time = math.floor(self._file.cha.mtime or 0)
-- 	time = time and os.date("%g-%m-%d %H:%M", time) or ""
-- 	return ui.Line(string.format(time))
-- end
function Linemode:mtimev2()
	-- maybe format to %g-%m-%d %H:%M
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%m-%d %H:%M", time)
	else
		time = os.date("%m/%Y", time)
	end
	return ui.Line(string.format(time))
end

-- Eza
require("eza-preview"):setup({
	default_tree = false,
	level = 1,
})
require("duckdb"):setup()

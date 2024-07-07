-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
    -- nightfox theme is the best for me probably
	theme = "nightfox",
    hl_override = {
        CursorLineNr = { fg = "yellow" },
    },
    -- statusline = {
    --     order = { "mode", "git", "cwd"},
    -- },
    tabufline = {
        enable = false,
    },
}

return M

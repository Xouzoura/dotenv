-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {
  ui = {
    statusline = {
      order = { "mode", "path", "file", "%=", "git", "lsp_msg" },
      modules = {
        path = function()
          local relative_path = vim.fn.expand "%:.:h"
          local icon = "󰉋"
          return string.format("%%#StatusLinePath#%s  ~/%s  %%#StatusLine#", icon, relative_path)
        end,
      },
    },
    tabufline = {
      enabled = false,
    },
  },
  term = {},
  base46 = {
    -- [nightfox] theme is the best for me probably
    theme = "nightfox",
    hl_override = {
      CursorLineNr = { fg = "yellow" },
    },
  },
}

return M

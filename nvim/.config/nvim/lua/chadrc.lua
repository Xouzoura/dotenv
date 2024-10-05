-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {
  ui = {
    statusline = {
      order = { "mode", "file", "git", "lsp_msg", "%=", "diagnostics", "cursor" },
      modules = {
        cursor = function()
          local function get_python_path()
            local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"

            if vim.fn.filereadable(venv_path) == 1 then
              return ".venv"
            else
              return ""
            end
          end

          if vim.bo.filetype == "python" then
            val = get_python_path()
          else
            val = ""
          end
          return "%#BruhHl#" .. val
        end,
      },
    },
    tabufline = {
      enable = false,
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

-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {
  ui = {
    statusline = {
      order = { "mode", "path", "file", "diagnostics", "%=", "lsp_msg", "lsp_load", "cursor" },
      modules = {

        lsp_load = function()
          local loaded = #vim.lsp.get_clients { bufnr = 0 } > 0
          if not loaded then
            return " LSP ✗ | "
          end
          local status = vim.lsp.status()
          if status ~= "" then
            return " LSP ✗ | "
          end
          return " LSP ✓ | "
        end,
        path = function()
          local max_length = 40
          local relative_path = vim.fn.expand "%:.:h"
          local icon = "󰉋"
          -- format if it's a home path to show it, instead of relative path.
          local formatted_path = relative_path:match "^/home" and relative_path or "~/" .. relative_path
          --
          -- Truncate long paths
          if #formatted_path > max_length then
            local parts = vim.split(formatted_path, "/")
            if #parts > 5 then
              formatted_path = table.concat({
                parts[1], -- usually empty.
                parts[2],
                parts[3],
                "...",
                parts[#parts - 1],
                parts[#parts],
              }, "/")
            end
          end
          return string.format("%%#StatusLinePath#%s  %s  %%#StatusLine#", icon, formatted_path)
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

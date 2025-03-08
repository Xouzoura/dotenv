return {
  -- Highlight the undo
  "tzachar/highlight-undo.nvim",
  lazy = false,
  config = function()
    require("highlight-undo").setup {
      duration = 500,
    }
  end,
}
-- return {
--   "iguanacucumber/highlight-actions.nvim",
--   keys = { "u", "U", "p" }, -- Lazy load on keymap
--   opts = {
--     highlight_for_count = true, -- Should '3p' or '5u' be highlighted
--     duration = 300, -- Time in ms for the highlight
--     actions = {
--       Undo = {
--         disabled = false,
--         fg = "#dcd7ba",
--         bg = "#2d4f67",
--         mode = "n",
--         keymap = "u", -- mapping
--         cmd = "undo", -- Vim command
--         opts = {}, -- silent = true, desc = "", ...
--       },
--       Redo = {
--         disabled = false,
--         fg = "#dcd7ba",
--         bg = "#2d4f67",
--         mode = "n",
--         keymap = "U",
--         cmd = "redo",
--         opts = {},
--       },
--       Pasted = {
--         disabled = false,
--         fg = "#dcd7ba",
--         bg = "#2d4f67",
--         mode = "n",
--         keymap = "p",
--         cmd = "put",
--         opts = {},
--       },
--       -- Any other actions you might wanna add
--     },
--   },
-- }

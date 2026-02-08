-- Print easily some debug messages (like print in python, console.log in JS, etc.)
-- to the file with easy to use keymaps and commands.
-- Add <leader>dp to print the variable under the cursor below the current line.
--
return {
  "andrewferrier/debugprint.nvim",
  lazy = false,
  enabled = false,
  opts = {
    keymaps = {
      normal = {
        plain_below = "<leader>dp",
        plain_above = "<leader>dP",
        variable_below = "<leader>dk",
        variable_above = "<leader>dK",
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
        textobj_below = nil,
        textobj_above = nil,
        toggle_comment_debug_prints = "<leader>dD",
        delete_debug_prints = "<leader>dd",
      },
      -- visual = {
      --   variable_below = "g?v",
      --   variable_above = "g?V",
      -- },
    },
    commands = {
      toggle_comment_debug_prints = "ToggleCommentDebugPrints",
      delete_debug_prints = "DeleteDebugPrints",
    },
    -- … Other options
  },
}

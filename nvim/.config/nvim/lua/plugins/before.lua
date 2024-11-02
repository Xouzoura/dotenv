return {
  -- Way to jump between the edits that I have made (ctrl+q, ctrl+e, leader+oq, leader+oe)
  "bloznelis/before.nvim",
  lazy = false,
  config = function()
    local before = require "before"
    before.setup()

    vim.keymap.set("n", "<M-p>", before.jump_to_last_edit, {})
    vim.keymap.set("n", "<M-n>", before.jump_to_next_edit, {})
    --
    -- -- Look for previous edits in quickfix list
    -- vim.keymap.set("n", "<leader>oq", before.show_edits_in_quickfix, {})
    --
    -- -- Look for previous edits in telescope (needs telescope, obviously)
    -- vim.keymap.set("n", "<leader>oe", before.show_edits_in_telescope, {})
  end,
}

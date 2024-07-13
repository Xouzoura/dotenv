return {
  -- Way to jump between the edits that I have made (ctrl+q, ctrl+e, leader+oq, leader+oe)
  "bloznelis/before.nvim",
  lazy = false,
  config = function()
    local before = require "before"
    before.setup()

    -- Jump to previous entry in the edit history
    vim.keymap.set("n", "<C-q>", before.jump_to_last_edit, {})

    -- Jump to next entry in the edit history
    vim.keymap.set("n", "<C-e>", before.jump_to_next_edit, {})

    -- Look for previous edits in quickfix list
    vim.keymap.set("n", "<leader>oq", before.show_edits_in_quickfix, {})

    -- Look for previous edits in telescope (needs telescope, obviously)
    vim.keymap.set("n", "<leader>oe", before.show_edits_in_telescope, {})
  end,
}

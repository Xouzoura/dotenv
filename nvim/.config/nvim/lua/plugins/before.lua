return {
  -- Way to jump between the edits that I have made (alt+p, alt+n)
  "bloznelis/before.nvim",
  lazy = false,
  keys = {
    {
      "<M-p>",
      function()
        require("before").jump_to_last_edit()
      end,
      desc = "Jump to last edit",
    },
    {
      "<M-n>",
      function()
        require("before").jump_to_next_edit()
      end,
      desc = "Jump to next edit",
    },
    -- Optional leader bindings:
    -- { "<leader>oq", function() require("before").show_edits_in_quickfix() end, desc = "Edits in quickfix" },
    -- { "<leader>oe", function() require("before").show_edits_in_telescope() end, desc = "Edits in telescope" },
  },
  config = function()
    require("before").setup()
  end,
}

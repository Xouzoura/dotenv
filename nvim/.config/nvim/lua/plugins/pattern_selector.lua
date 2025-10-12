return {
  -- regex, uuids etc
  "Xouzoura/pattern-selector",
  branch = "master",
  keys = {
    {
      "<leader>cu",
      function()
        require("pattern_selector").FindAndSelectPattern()
      end,
      desc = "Find and select pattern",
    },
    {
      "<leader>cr",
      function()
        require("pattern_selector").ReplaceWithClipboard()
      end,
      desc = "Replace with clipboard",
    },
  },
  config = function(_, opts)
    require("pattern_selector").setup(opts)
  end,
}

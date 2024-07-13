return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    -- labels = "asdfghjklqwertyuiopzxcvbnm",
    -- char = {
    --   keys = { "f", "F", "t", "T", ";", "," },
    --   char_actions = function(motion)
    --     return {
    --       [","] = "prev", -- Change to move to the previous match
    --       ["."] = "next", -- Change to move to the next match
    --       -- clever-f style
    --       [motion:lower()] = "next",
    --       [motion:upper()] = "prev",
    --     }
    --   end,
    -- },
    label = {
      rainbow = {
        enabled = true, -- Enable rainbow colors to highlight labels
        shade = 5, -- Adjust the number between 1 and 9 for different shades
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}

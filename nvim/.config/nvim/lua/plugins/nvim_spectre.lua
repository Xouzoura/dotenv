return {
  "nvim-pack/nvim-spectre",
  lazy = true, -- only load on key press
  keys = {
    {
      "<leader>r;",
      function()
        require("spectre").toggle()
      end,
      desc = "<Spectre> Toggle",
    },
    {
      "<leader>rc",
      function()
        require("spectre").open_visual { select_word = true }
      end,
      mode = "n",
      desc = "<Spectre> Replace word",
    },
    {
      "<leader>rc",
      function()
        require("spectre").open_visual()
      end,
      mode = "v",
      desc = "<Spectre> Replace visual selection",
    },
    {
      "<leader>rf",
      function()
        require("spectre").open_file_search { select_word = true }
      end,
      desc = "<Spectre> Search on current file",
    },
  },
  config = function()
    require("spectre").setup {
      result_padding = "",
      default = {
        replace = {
          cmd = "sed",
        },
      },
    }
  end,
}

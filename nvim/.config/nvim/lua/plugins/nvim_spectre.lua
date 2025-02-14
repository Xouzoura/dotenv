return {
  -- Search and replace within all the files
  "nvim-pack/nvim-spectre",
  lazy = false,
  config = function()
    require("spectre").setup {
      result_padding = "",
      default = {
        replace = {
          cmd = "sed",
        },
      },
    }
    local map = vim.keymap.set
    map("n", "<leader>r;", '<cmd>lua require("spectre").toggle()<CR>', {
      desc = "<Spectre> Toggle",
    })
    map("n", "<leader>rc", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "<Spectre> Replace word",
    })
    map("v", "<leader>rc", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = "<Spectre> Replace visual selection",
    })
    map("n", "<leader>rf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = "<Spectre> Search on current file",
    })
  end,
}

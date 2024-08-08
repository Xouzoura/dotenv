return {
  -- Search and replace within all the files
  "nvim-pack/nvim-spectre",
  config = function()
    require("spectre").setup {
      -- mapping space + S, sw, sp,
      result_padding = "",
      default = {
        replace = {
          cmd = "sed",
        },
      },
    }
    local map = vim.keymap.set
    map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
      desc = "Toggle Spectre",
    })
    map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "Search current word",
    })
    map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = "Search current word",
    })
    map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = "Search on current file",
    })
  end,
}

return {
  "DanWlker/toolbox.nvim",
  lazy = false,
  config = function()
    require("toolbox").setup {
      commands = {
        --replace the bottom two with your own custom functions
        {
          name = "Format Json",
          execute = "!jq '.'",
          require_input = true,
        },
        {
          name = "Switch Bearer Token",
          execute = "/BEARER<CR> /lln :w<CR>",
          require_input = false,
        },
      },
    }

    vim.keymap.set("n", "<leader>st", require("toolbox").show_picker, { desc = "[S]earch [T]oolbox" })
  end,
}

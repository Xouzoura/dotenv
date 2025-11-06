return {
  "necrom4/convy.nvim",
  cmd = "Convy",
  opts = {},
  keys = {
    -- example keymaps
    {
      "<leader>cc",
      ":Convy<CR>",
      desc = "[convy] Convert (interactive selection)",
      mode = { "n", "v" },
      silent = true,
    },
  },
}

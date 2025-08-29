return {
  "piersolenski/import.nvim",
  dependencies = {
    -- One of the following pickers is required:
    -- "nvim-telescope/telescope.nvim",
    -- 'folke/snacks.nvim',
    "ibhagwan/fzf-lua",
  },
  opts = {
    picker = "fzf-lua",
  },
  keys = {
    {
      "<leader>I",
      function()
        require("import").pick()
      end,
      desc = "Import",
    },
  },
}

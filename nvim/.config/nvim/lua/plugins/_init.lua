-- Only contains setup/lspconfigs and other language related plugins
return {
  {
    "williamboman/mason.nvim",
    -- No need to add this with new nvchad.
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    lazy = false,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },
  {
    -- Default conform setup for saving files
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },
  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
}

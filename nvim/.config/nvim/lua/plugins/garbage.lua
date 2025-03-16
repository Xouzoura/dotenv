return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    excluded_lsp_clients = { "GitHub Copilot" },
    grace_period = 60 * 30, -- 30 mins
    notifications = true,
  },
}

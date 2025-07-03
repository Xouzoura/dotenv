return {
  "zeioth/garbage-day.nvim",
  dependencies = "neovim/nvim-lspconfig",
  event = "VeryLazy",
  enabled = false, -- causing some issues lately
  opts = {
    excluded_lsp_clients = { "GitHub Copilot" },
    grace_period = 60 * 30, -- 30 mins
    notifications = true,
  },
}

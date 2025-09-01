return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  -- lazy = false,
  -- ft = "python", -- somehow when enabled causes issues when opening files with fzf-lua.
  opts = { options = { picker = "fzf-lua" } },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>" },
  },
}

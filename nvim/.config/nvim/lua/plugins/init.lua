-- Only contains setup/lspconfigs and other language related plugins
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "black",
        "debugpy",
        "pyright",
        "mypy",
        -- "ruff",
        "isort",
        -- "tsserver",
        "clangd",
        "eslint-lsp",
        -- go
        "gopls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
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
}

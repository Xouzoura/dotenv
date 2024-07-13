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
  -- {
  --     "jose-elias-alvarez/null-ls.nvim",
  --     ft = {"python"},
  --     opts = function()
  --         return require "configs.null-ls"
  --     end,
  -- },
  {
    -- Default conform setup for lua, python, javascript, c
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
}

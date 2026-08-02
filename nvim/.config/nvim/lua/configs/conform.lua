local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = { "prettier" },
    c = { "clang-format" },
  },
  formatters = {
    ruff_format = {
      command = "ruff",
      args = {
        "format",
        "--force-exclude",
        "--stdin-filename",
        "$FILENAME",
        "-",
        "--line-length",
        "88",
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- python = { "black" },
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
        "--line-length", -- This is because of stupid local forces.
        -- "88", -- this should be the pep8 standard
        "120", -- this is in my most pre-commits
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)

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
        -- "120", -- This is because of stupid local forces. WILL REMOVE WHEN OUT.
        "88", -- this should be the pep8 standard
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)

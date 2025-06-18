return {
  -- Ephemeral git open locally
  -- examples:
  -- -- :GitDevOpen derailed/k9s {tag="v0.32.4"}
  -- -- :GitDevOpen derailed/k9s
  -- -- :GitDevOpen echasnovski/mini.nvim {branch="stable"}
  "moyiz/git-dev.nvim",
  lazy = true,
  cmd = {
    "GitDevClean",
    "GitDevCleanAll",
    "GitDevCloseBuffers",
    "GitDevOpen",
    "GitDevRecents",
    "GitDevToggleUI",
    "GitDevXDGHandle",
  },
  opts = {},
}

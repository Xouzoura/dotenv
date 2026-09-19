return {
  "rmagatti/auto-session",
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_save = false,
    -- log_level = 'debug',
  },
  keys = {
    { "<leader>ss", "<cmd>AutoSession save<CR>", desc = "<auto-session> Save session" },
    { "<leader>sl", "<cmd>AutoSession restore<CR>", desc = "<auto-session> Restore session" },
    { "<leader>sd", "<cmd>AutoSession delete<CR>", desc = "<auto-session> Delete session" },
    { "<leader>sf", "<cmd>AutoSession search<CR>", desc = "<auto-session> Search session" },
  },
}

return {
  "nvim-orgmode/orgmode",
  -- dir = "/home/xouzoura/code/lua/_plugins/orgmode/",
  event = "VeryLazy",
  config = function()
    -- Setup orgmode
    require("orgmode").setup {
      -- org_agenda_files = "~/orgfiles/**",
      -- org_default_notes_file = "~/orgfiles/refile.org",
      org_agenda_files = "~/vaults/notes/orgfiles/**",
      org_default_notes_file = "~/vaults/notes/orgfiles/refile.org",
    }
  end,
  keys = {
    -- { "<Leader>r", "<cmd>Repl<cr>", mode = "n", desc = "<Repl> Create" },
    { "<Leader>oO", ":edit ~/vaults/notes/orgfiles/refile.org<cr>", mode = "n", desc = "<org> refile.org" },
    { "<Leader>od", ":edit ~/vaults/notes/orgfiles/personal.org<cr>", mode = "n", desc = "<org> personal.org" },
    { "<Leader>ow", ":edit ~/vaults/notes/orgfiles/work.org<cr>", mode = "n", desc = "<org> work.org" },
  },
}

return {
  -- Ephemeral git open locally with a simple :GitDevOpen Xouzoura/hurl.nvim
  -- examples:
  -- -- :GitDevOpen derailed/k9s {tag="v0.32.4"}
  -- -- :GitDevOpen derailed/k9s
  -- -- :GitDevOpen echasnovski/mini.nvim {branch="stable"}
  -- -- :GitDevOpen https://github.com/Xouzoura/hurl.nvim/tree/feat/add-file-root-as-default-path
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
  keys = {
    { "<Leader>gor", "<cmd>GitDevRecents<cr>", desc = "GitDev: Recents" },
    { "<Leader>goc", "<cmd>GitDevCleanAll<cr>", desc = "GitDev: Clean all" },
    { "<Leader>goq", "<cmd>GitDevCloseBuffers<cr>", desc = "GitDev: Close buffers" },
    {
      "<Leader>goh",
      function()
        local path = vim.fn.stdpath "data" .. "/git-dev/history.json"
        if vim.fn.filereadable(path) == 1 then
          os.remove(path)
          vim.notify("Deleted git-dev history.json", vim.log.levels.INFO)
        else
          vim.notify("No git-dev history file found", vim.log.levels.WARN)
        end
      end,
      desc = "GitDev: Delete history.json",
    },
    {
      "<Leader>gop",
      function()
        local clipboard = vim.fn.getreg "+"

        -- Match GitHub repo (supports SSH, HTTPS, etc.)
        local user, repo = clipboard:match "github.com[/:]([%w%-_.]+)/([%w%-_.]+)"
        if not user or not repo then
          vim.notify("No valid GitHub repo found in clipboard '" .. clipboard .. "'", vim.log.levels.WARN)
          return
        end

        local command = "GitDevOpen " .. clipboard
        print("Opening the repo as .. ", command)
        vim.cmd(command)
      end,
      desc = "GitDevOpen: cliboard",
    },
  },
}

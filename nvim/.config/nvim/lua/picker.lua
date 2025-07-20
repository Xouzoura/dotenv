-- THIS IS until i decide that fzf-lua is better than telescope.
-- I have the option to set the USE_FZF_LUA = false, which will revert to what
-- i already had.
-- will leave here global selectors between libraries just in case
local M = {}

M.USE_FZF_LUA = true -- true = fzf-lua, false = telescope
-- M.USE_FZF_LUA = false

if M.USE_FZF_LUA then
  M.FZF_LUA_KEYS = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "(fzf) Find Files",
    },
    {
      -- use the plugin that has a history of opened files
      "<leader><leader>",
      function()
        require("fzf-lua-enchanted-files").files()
      end,
      desc = "(fzf) Find Files (enchanted)",
    },
    {
      -- do a live grep search
      "<leader>fw",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "(fzf) Live Grep",
    },
    {
      -- rerun last grep search
      "<leader>fl",
      function()
        require("fzf-lua").grep_last()
      end,
      desc = "(fzf) Last grep",
    },
    {
      -- oldfiles but globally
      "<leader>fO",
      function()
        require("fzf-lua").oldfiles {}
      end,
      desc = "(fzf) Oldfiles global",
    },
    {
      -- oldfiles, but cwd only
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles { cwd = vim.loop.cwd() }
      end,
      desc = "(fzf) Oldfiles in CWD",
    },
    {
      -- grep with word under cursor
      "<leader>fe",
      function()
        local fzf = require "fzf-lua"
        local word = vim.fn.expand "<cword>"
        fzf.live_grep { search = word }
      end,
      desc = "(fzf) Live Grep (word under cursor)",
    },
    {
      -- grep with word under cursor
      "<leader>fE",
      function()
        local fzf = require "fzf-lua"
        local word = vim.fn.expand "<cWORD>"
        fzf.live_grep { search = word }
      end,
      desc = "(fzf) Live Grep (WORD under cursor)",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "(fzf) Buffers",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "(fzf) Diagnostics (buffer)",
    },
    {
      "<leader>fD",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "(fzf) Diagnostics (workspace)",
    },
    {
      "<Tab>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "(fzf) Buffers",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "(fzf) Keymaps",
    },
    {
      "<leader>f.",
      function()
        local fzf = require "fzf-lua"
        local file_dir = vim.fn.expand "%:p:h"
        print(file_dir)
        fzf.live_grep { cwd = file_dir }
      end,
      desc = "(fzf) Search grep in current file's directory",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua").grep_curbuf()
      end,
      desc = "(fzf) Search in current file only",
    },
    {
      "<leader>fE",
      function()
        local fzf = require "fzf-lua"
        local word = vim.fn.expand "<cword>" -- word under cursor
        fzf.grep_curbuf { search = word }
      end,
      desc = "(fzf) Search WORD in current file",
    },
    -- Git stuff
    {
      "<leader>ga",
      function()
        require("fzf-lua").git_commits()
      end,
      desc = "(fzf) Git diff for whole project",
    },
    {
      "<leader>gf",
      function()
        require("fzf-lua").git_bcommits()
      end,
      desc = "(fzf) Git diff for current file",
    },
    -- resume
    {
      "<leader>fs",
      function()
        require("fzf-lua").resume()
      end,
    },
  }
  M.TELESCOPE_REMOVE = {
    "<leader>fz",
    "<leader>fw",
    "<leader>ff",
    "<leader>fb",
    "<leader>fa",
    "<leader>fo",
    "<leader>fh",
    "<leader>ma",
    "<leader>pt",
    "<leader>gt",
    "<leader>cm",
  }
else
  -- NOTE: These are loaded by nvchad
  -- map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
  -- map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
  -- map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
  -- map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
  -- map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
  -- map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
  -- map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
  -- map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
  -- map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

  -- local live_grep_args_shortcuts = require "telescope-live-grep-args.shortcuts"

  local extras = require "extras"
  M.FZF_LUA_KEYS = {
    {
      "<leader>fe",
      "<cmd>Telescope grep_string<cr>",
      desc = "[P] Find grep current word",
    },
    {
      "<leader>f.",
      function()
        local file_dir = vim.fn.expand "%:p:h" -- Get the current file's directory
        require("telescope.builtin").live_grep { search_dirs = { file_dir } }
      end,
      desc = "[P] Search grep in current file's directory",
    },
    {
      "<leader>fc",
      function()
        local current_file = vim.fn.expand "%:p" -- Get full path of current file
        require("telescope.builtin").live_grep { search_dirs = { current_file } }
      end,
      desc = "Search grep in current file",
    },
    {
      "<leader>fk",
      ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
      desc = "Telescope Live Grep Args",
    },
    { "<leader>gf", "<cmd>Telescope git_bcommits<CR>", desc = "Search git bcommits on current <f>ile" },
    { "<leader>ga", "<cmd>Telescope git_commits<CR>", desc = "Search git commits on <a>ll files" },
    -- terminal of open buffers
    --TODO: keep only one from the below.
    -- Tab does also include the c-i.
    -- map("n", "<Tab>", extras.open_buffers, { silent = true, noremap = true, desc = "[P]Open telescope buffers" })
    { "<Tab>", extras.open_buffers, desc = "[P]Open telescope buffers" },
  }
  M.TELESCOPE_REMOVE = {}
end
return M

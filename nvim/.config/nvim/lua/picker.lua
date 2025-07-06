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
      "<leader><leader>",
      function()
        require("fzf-lua-enchanted-files").files()
      end,
      desc = "(fzf) Find Files",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "(fzf) Live Grep",
    },
    {
      "<leader>fO",
      function()
        require("fzf-lua").oldfiles {}
      end,
      desc = "(fzf) Oldfiles",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles { cwd = vim.loop.cwd() }
      end,
      desc = "(fzf) Oldfiles",
    },
    {
      "<leader>fe",
      function()
        local fzf = require "fzf-lua"
        local word = vim.fn.expand "<cword>" -- word under cursor
        fzf.live_grep { search = word }
      end,
      desc = "(fzf) Live Grep (word)",
    },
    {
      "<leader>fb",
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
      desc = "cfzfc Search WORD in current file",
    },
    {
      "leader>fs",
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
  }
  M.TELESCOPE_REMOVE = {}
end
return M

return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    -- enabled = _enabled,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    keys = {
      {
        "<leader>ff",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.files()
        end,
        desc = "(fzf) Find Files",
      },
      {
        -- use the plugin that has a history of opened files
        "<leader><leader>",
        function()
          -- require("fzf-lua-enchanted-files").files()
          local fzf_lua = require "fzf-lua"
          fzf_lua.files()
        end,
        desc = "(fzf) Find Files (enchanted)",
      },
      {
        -- do a live grep search
        "<leader>fw",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.live_grep()
        end,
        desc = "(fzf) Live Grep",
      },
      {
        -- do a quickfix
        "<leader>fq",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.quickfix()
        end,
        desc = "(fzf) Quickfix",
      },
      {
        -- do a quickfix stack
        "<leader>fQ",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.quickfix_stack()
        end,
        desc = "(fzf) Quickfix Stack",
      },
      {
        -- rerun last grep search
        "<leader>fl",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.grep { resume = true }
        end,
        desc = "(fzf) Last grep",
      },
      {
        -- oldfiles but globally
        "<leader>fO",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.oldfiles {}
        end,
        desc = "(fzf) Oldfiles global",
      },
      {
        -- oldfiles, but cwd only
        "<leader>fo",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.oldfiles { cwd = vim.loop.cwd() }
        end,
        desc = "(fzf) Oldfiles in CWD",
      },
      {

        "<leader>fp",
        function()
          local fzf_lua = require "fzf-lua"
          -- local word = vim.fn.expand "<cword>"
          local clipboard = vim.fn.getreg "+"
          fzf_lua.live_grep { search = clipboard }
        end,
        desc = "(fzf) Live Grep (word in clipboard)",
      },
      {
        -- grep with word under cursor
        "<leader>fe",
        function()
          local fzf_lua = require "fzf-lua"
          local word = vim.fn.expand "<cword>"
          fzf_lua.live_grep { search = word }
        end,
        desc = "(fzf) Live Grep (word under cursor)",
      },
      {
        -- grep with word under cursor
        "<leader>fE",
        function()
          local fzf_lua = require "fzf-lua"
          local word = vim.fn.expand "<cWORD>"
          fzf_lua.live_grep { search = word }
        end,
        desc = "(fzf) Live Grep (WORD under cursor)",
      },
      {
        "<leader>fLi",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.lsp_outgoing_calls {}
        end,
        desc = "(fzf) LSP [i]ncoming [c]alls",
      },
      -- {
      --   "<leader>fB",
      --   function()
      --     local fzf_lua = require "fzf-lua"
      --     fzf_lua.buffers()
      --   end,
      --   desc = "(fzf) Buffers",
      -- },
      {
        "<leader>fbd",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.diagnostics_document()
        end,
        desc = "(fzf) Diagnostics (buffer)",
      },
      {
        "<leader>fd",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.diagnostics_workspace()
        end,
        desc = "(fzf) Diagnostics (workspace)",
      },
      {
        "<Tab>",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.buffers()
        end,
        desc = "(fzf) Buffers",
      },
      {
        "<leader>fk",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.keymaps()
        end,
        desc = "(fzf) Keymaps",
      },
      {
        "<leader>f.",
        function()
          local fzf_lua = require "fzf-lua"
          local file_dir = vim.fn.expand "%:p:h"
          fzf_lua.live_grep { cwd = file_dir }
        end,
        desc = "(fzf) Search grep in current file's directory",
      },
      {
        "<leader>fbw",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.grep_curbuf()
        end,
        desc = "(fzf) Search in current file only",
      },
      {
        "<leader>fbe",
        function()
          local fzf_lua = require "fzf-lua"
          local word = vim.fn.expand "<cword>" -- word under cursor
          fzf_lua.grep_curbuf { search = word }
        end,
        desc = "(fzf) Search WORD in current file",
      },
      -- Git stuff
      {
        "<leader>fga",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.git_commits()
        end,
        desc = "(fzf) Git diff for whole project",
      },
      {
        "<leader>fgb",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.git_bcommits()
        end,
        desc = "(fzf) Git diff for current file",
      },
      -- resume
      {
        "<leader>f;",
        function()
          local fzf_lua = require "fzf-lua"
          fzf_lua.resume()
        end,
        desc = "(fzf) Continue search",
      },
      -- My personal one because i tend to search prints a lot.
      {
        "<leader>fp",
        function()
          require("fzf-lua").live_grep {
            search = "print(",
          }
        end,
        desc = "(fzf) Show prints",
      },
      {
        "<leader>ft",
        function()
          require("fzf-lua").files {
            cmd = "rg --files --glob 'test_*.py'",
          }
        end,
        desc = "(fzf) Find 'test_' files",
      },
    },
    opts = function()
      local actions = require("fzf-lua").actions

      return {
        keymap = {
          -- Below are the default binds, setting any value in these tables will override
          -- the defaults, to inherit from the defaults change [1] from `false` to `true`
          builtin = {
            -- true,
            false,
            ["<M-Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            -- Only valid with the 'builtin' previewer
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            -- Rotate preview clockwise/counter-clockwise
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            -- `ts-ctx` binds require `nvim-treesitter-context`
            ["<F7>"] = "toggle-preview-ts-ctx",
            ["<F8>"] = "preview-ts-ctx-dec",
            ["<F9>"] = "preview-ts-ctx-inc",
            ["<S-Left>"] = "preview-reset",
            ["<M-S-down>"] = "preview-down",
            ["<M-S-up>"] = "preview-up",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            -- true,
            false,
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-r"] = "select-all+accept",
            ["ctrl-z"] = "abort",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            ["alt-g"] = "first",
            ["alt-G"] = "last",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        winopts = {
          height = 0.85,
          width = 0.85,
          row = 0.35,
          col = 0.50,
          preview = {
            layout = "vertical",
            vertical = "right:50%",
            horizontal = "right:50%",
            wrap = true,
            hidden = "nohidden",
          },
          border = "rounded",
          fullscreen = false,
        },
        buffers = {
          prompt = "❯❯ ",
          file_icons = true,
          color_icons = true,
          sort_lastused = true,
          show_unloaded = true,
          cwd_only = false,
          cwd = nil,
          actions = {
            ["ctrl-c"] = { fn = actions.buf_del, reload = true },
          },
        },
      }
    end,
    -- This is to be able to select the ui_select. Will see if it works
    -- by default it is not enabled, helps when searching for it
    config = function(_, opts)
      local fzf_lua = require "fzf-lua"
      fzf_lua.setup(opts)
      fzf_lua.register_ui_select()
    end,
  },
  {
    "otavioschwanck/fzf-lua-enchanted-files",
    dependencies = { "ibhagwan/fzf-lua" },
    -- enabled = _enabled,
    enabled = false,
    config = function()
      -- Modern configuration using vim.g
      vim.g.fzf_lua_enchanted_files = {
        max_history_per_cwd = 50,
      }
    end,
    -- opts = {},
  },
  {
    -- NOTE: lots of plugins use telescope and give warnings if it doesn't exist.
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}

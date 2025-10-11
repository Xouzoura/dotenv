local picker = require "picker"
local _enabled = picker.USE_FZF_LUA
return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    enabled = _enabled,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    keys = picker.FZF_LUA_KEYS,
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
    enabled = _enabled,
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
    -- or                              , branch = '0.1.x',
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}

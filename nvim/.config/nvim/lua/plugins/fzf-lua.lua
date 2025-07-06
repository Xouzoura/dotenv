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
            ["d"] = { fn = actions.buf_del, reload = true },
          },
        },
      }
    end,
  },
  {
    "otavioschwanck/fzf-lua-enchanted-files",
    dependencies = { "ibhagwan/fzf-lua" },
    enabled = _enabled,
    opts = {},
  },
}

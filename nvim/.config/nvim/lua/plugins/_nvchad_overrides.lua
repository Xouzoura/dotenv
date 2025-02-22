return {
  {
    -- Plugin: nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local custom = require "nvchad.configs.nvimtree"
      -- Remove default keymaps and add new ones

      custom.filters.dotfiles = false
      custom.git = custom.git or {}
      custom.git.ignore = false

      -- Add custom highlighting configuration
      custom.renderer = custom.renderer or {}
      custom.renderer.highlight_opened_files = "all"
      custom.renderer.icons = custom.renderer.icons or {}
      custom.renderer.icons.show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      }
      -- Add actions configuration to disable window picker (A or B), I just want to open.
      custom.actions = custom.actions or {}
      custom.actions.open_file = custom.actions.open_file or {}
      custom.actions.open_file.window_picker = {
        enable = false,
      }
      -- Configure to update focus when entering a buffer
      custom.update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      }

      -- Add custom highlighting colors
      vim.cmd [[
          highlight NvimTreeOpenedFile guifg=#8e7cc3
          highlight NvimTreeCursorLine guibg=#b4a7d6
      ]]

      return custom
    end,
  },
  {
    -- Plugin: nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    opts = function()
      local custom = require "nvchad.configs.telescope"
      custom.defaults.mappings = {
        n = { ["q"] = require("telescope.actions").close, ["d"] = require("telescope.actions").delete_buffer },
      }
      return custom
    end,
  },
  -- More plugins
  {
    -- because nvchad doesn't load this plugin by default, so i don't need to press space two times
    "folke/which-key.nvim",
    lazy = false,
  },
}

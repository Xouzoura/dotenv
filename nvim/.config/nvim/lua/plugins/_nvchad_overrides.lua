return {
  {
    -- Plugin: nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    opts = function()
      custom = require "nvchad.configs.nvimtree"
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
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   config = function()
  --     require("telescope").setup {
  --       defaults = {
  --         file_ignore_patterns = { ".git/.*", "node_modules/.*", ".cache/.*" },
  --       },
  --       extensions = {
  --         fzf = {
  --           fuzzy = true, -- false will only do exact matching
  --           override_generic_sorter = true, -- override the generic sorter
  --           override_file_sorter = true, -- override the file sorter
  --           case_mode = "smart_case", -- or "ignore_case" or "respect_case"
  --           -- the default case_mode is "smart_case"
  --         },
  --       },
  --     }
  --     require("telescope").load_extension "fzf"
  --   end,
  -- },
  -- More plugins
}

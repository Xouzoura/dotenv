return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      custom = require "nvchad.configs.nvimtree"
      custom.filters.dotfiles = false 
      custom.git.ignore = false 
      return custom  
    end,
  },
}

  -- return {
  --   "nvim-tree/nvim-tree.nvim",
  --   opts = function()
  --     local conf = require "nvchad.configs.nvim-tree"
  --     conf.filters.dotfiles = true
  --     -- conf.defaults.mappings.i = {
  --     --   ["<C-j>"] = require("telescope.actions").move_selection_next,
  --     --   ["<Esc>"] = require("telescope.actions").close,
  --     -- }
  --    -- or 
  --    -- table.insert(conf.defaults.mappings.i, your table)
  --
  --     return conf
  --   end,
  -- }

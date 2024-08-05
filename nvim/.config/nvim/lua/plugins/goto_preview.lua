return {
  -- {
  --   -- preview with gp
  --   "rmagatti/goto-preview",
  --   lazy = false,
  --   config = function()
  --     require("goto-preview").setup {
  --       default_mappings = true,
  --       -- mappings: gp + d,D,i,r,t
  --     }
  --   end,
  -- },
  {
    -- preview with glance. <leader>l to go to definition
    "dnlhc/glance.nvim",
    lazy = false,
    config = function()
      require("glance").setup {
        -- your configuration
      }
      vim.keymap.set("n", "gpd", "<CMD>Glance definitions<CR>")
      vim.keymap.set("n", "gpr", "<CMD>Glance references<CR>")
      vim.keymap.set("n", "gpt", "<CMD>Glance type_definitions<CR>")
      -- vim.keymap.set("n", "gpi", "<CMD>Glance implementations<CR>")
    end,
  },
}

return {
  -- preview with gp
  "rmagatti/goto-preview",
  lazy = false,
  config = function()
    require("goto-preview").setup {
      default_mappings = true,
      -- mappings: gp + d,D,i,r,t
    }
  end,
}

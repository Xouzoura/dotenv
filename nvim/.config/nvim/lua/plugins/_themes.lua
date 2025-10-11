return {
  "EdenEast/nightfox.nvim",
  config = function()
    require("nightfox").setup {
      options = {
        styles = {
          keywords = "bold",
          types = "bold",
        },
      },
      palettes = {
        all = {
          red = "#ff0000",
        },
        nightfox = {
          red = "#c94f6d",
        },
        dayfox = {
          blue = { base = "#4d688e", bright = "#4e75aa", dim = "#485e7d" },
        },
        nordfox = {
          sel1 = "#4f6074", -- Popup sel bg, search bg
          comment = "#60728a",
        },
      },
      groups = {
        all = {
          Whitespace = { link = "Comment" },
          IncSearch = { bg = "palette.cyan" },
          -- Visual = { bg = "#d1d1c0", fg = "#ffffff" },
          Visual = { bg = "#999988", fg = "#ffffff" }, -- darker gray, white text
        },
        nightfox = {
          PmenuSel = { bg = "#73daca", fg = "bg0" },
          Visual = { bg = "#999988", fg = "#ffffff" }, -- darker gray, white text
        },
      },
    }
  end,
}

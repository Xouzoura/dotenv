return {
  -- Default folder with zA to fold current function
  "kevinhwang91/nvim-ufo",
  event = "BufEnter",
  dependencies = {
    "kevinhwang91/promise-async",
    -- Second dependency is to remove the useless numbers on the side.
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require "statuscol.builtin"
        require("statuscol").setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          },
        }
      end,
    },
  },

  config = function()
    require("ufo").setup {
      -- zA to fold ``
      provider_selector = function(_bufnr, _filetype, _buftype)
        return { "treesitter", "indent" }
      end,
    }
  end,
}

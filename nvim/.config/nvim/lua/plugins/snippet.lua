-------------
-- LuaSnip --
-------------
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- Use the latest v2 release
  build = "make install_jsregexp",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require "configs.luasnip"
  end,
}

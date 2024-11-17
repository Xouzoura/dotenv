local ls = require "luasnip"
local s = ls.snippet
local f = ls.function_node

-- Snippet for Unix datetime
ls.add_snippets("all", {
  s(
    "ts",
    f(function()
      return tostring(os.time())
    end)
  ),
  s(
    "``",
    f(function()
      return "- [ ] "
    end)
  ),
  s(
    "today",
    f(function()
      return os.date "%Y-%m-%d"
    end)
  ),
  s(
    "ignore",
    f(function()
      return "#type: ignore[]"
    end)
  ),
  s(
    "pn",
    f(function()
      return "@pytest.mark.new"
    end)
  ),
})

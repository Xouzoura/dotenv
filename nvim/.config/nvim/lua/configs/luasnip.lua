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
    "ll",
    f(function()
      return "- [ ] "
    end)
  ),
  s(
    "qs",
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
  s(
    "uuid",
    f(function()
      -- Use vim.loop to generate a UUID-like string (since lua doesn't have built-in UUID support)
      local random = math.random
      return string.format(
        "%08x-%04x-%04x-%04x-%12x",
        random(0, 0xffffffff),
        random(0, 0xffff),
        random(0, 0xffff),
        random(0, 0xffff),
        random(0, 0xffffffffffff)
      )
    end)
  ),
})

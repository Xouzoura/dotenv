return {
  "yarospace/lua-console.nvim",
  lazy = true,
  enabled = false,
  keys = "`",
  config = function()
    require("lua-console").setup {
      external_evaluators = {
        python = {
          cmd = { "python3", "-c" },
          env = { PYTHONPATH = "~/projects" },
          timeout = 100000,
        },
      },
    }
  end,
  opts = {},
}

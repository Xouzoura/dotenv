return {
  -- kubectl bindings, to be able to use kubectl from nvim. Still under work.
  "ramilito/kubectl.nvim",
  -- lazy = false,
  keys = {
    {
      "<leader>kb",
      function()
        require("kubectl").open()
      end,
      desc = "Kubectl",
    },
  },
  config = function()
    require("kubectl").setup()
  end,
}

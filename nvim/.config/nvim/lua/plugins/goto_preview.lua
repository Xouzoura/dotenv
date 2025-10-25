return {
  {
    -- preview with definitions etc
    "dnlhc/glance.nvim",
    lazy = false,
    config = function()
      local glance = require "glance"
      local actions = glance.actions
      glance.setup {
        mappings = {
          list = {
            ["<c-n>"] = actions.next, -- extra mappings
            ["<c-p>"] = actions.previous,
          },
        },
      }
      vim.keymap.set("n", "gpd", "<CMD>Glance definitions<CR>")
      vim.keymap.set("n", "gpr", "<CMD>Glance references<CR>")
      vim.keymap.set("n", "<c-space>", "<CMD>Glance definitions<CR>")
      -- vim.keymap.set("n", "gpt", "<CMD>Glance type_definitions<CR>")
      -- vim.keymap.set("n", "gpi", "<CMD>Glance implementations<CR>")
    end,
  },
}

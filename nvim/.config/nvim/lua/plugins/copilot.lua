-- <------------ Copilot
-- Option1: Copilot.lua
-- return {
--   "zbirenbaum/copilot.lua",
--   cmd = "Copilot",
--   -- event = "InsertEnter",
--   config = function()
--     require("copilot").setup {
--       suggestion = {
--         enabled = true,
--         auto_trigger = false,
--         hide_during_completion = true,
--         debounce = 75,
--         keymap = {
--           accept = "<M-l>",
--           accept_word = false,
--           accept_line = false,
--           next = "<M-]>",
--           prev = "<M-[>",
--           dismiss = "<C-]>",
--         },
--       },
--     }
--   end,
-- }
-- Option2: Copilot.vim
return {
  "github/copilot.vim",
  lazy = false,
  config = function()
    -- Copilot (enable/disable, but enabled by default) (plugins/copilot.lua)
    local map = vim.keymap.set
    map("n", "<leader>cpd", "<CMD>Copilot disable<CR>", { desc = "Disable copilot", noremap = true, silent = true })
    map("n", "<leader>cpe", "<CMD>Copilot enable<CR>", { desc = "Enable copilot", noremap = true, silent = true })
    map("i", "<C-]>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
    -- map("i", "<C-y>", 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
    map("i", "<M-[>", "copilot#Previous()", { silent = true, expr = true, replace_keycodes = false })
    map("i", "<M-]>", "copilot#Next()", { silent = true, expr = true, replace_keycodes = false })
  end,
}
--
--
-- Option3: Supermaven
-- return {
--   "supermaven-inc/supermaven-nvim",
--   lazy = false,
--   config = function()
--     require("supermaven-nvim").setup {
--       keymaps = {
--         accept_suggestion = "<C-]>",
--         clear_suggestion = "<C-[>",
--       },
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       -- refer to the configuration section below
--     }
--   end,
-- }
--
--
-- <------------ Codeium
--
-- Path: codeium.lua does not work at the moment
-- return {
--     "Exafunction/codeium.nvim",
--     -- lazy=false,
--     dependencies = {
--         "nvim-lua/plenary.nvim",
--         "hrsh7th/nvim-cmp",
--     },
--     config = function()
--         require("codeium").setup({
--         })
--     end
-- }
-- <------------ Sourcegraph
-- return {
--
--   "sourcegraph/sg.nvim",
--   lazy = false,
--   dependencies = { "nvim-lua/plenary.nvim" },
-- }

return {
  -- chatgpt in the nvim config
  "robitx/gp.nvim",
  lazy = false,
  config = function()
    local config = require "configs.gp-config"
    require("gp").setup(config)
    local function keymapOptions(desc)
      return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
      }
    end
    local map = vim.keymap.set
    map({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions "New Chat")
    map({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
    map({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions "Chat Finder")

    map("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions "Visual Chat New")
    map("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")
    map("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions "Visual Toggle Chat")
    map({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions "Popup")
    map({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions "Stop")
    map({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions "Next Agent")
  end,
}

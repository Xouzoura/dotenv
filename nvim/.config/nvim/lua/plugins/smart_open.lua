return {
  -- <space><space> that mixes the last opened files, buffers etc
  "danielfalk/smart-open.nvim",
  branch = "0.2.x",
  dependencies = {
    "kkharji/sqlite.lua",
    -- Only required if using match_algorithm fzf
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
  config = function()
    require("telescope").load_extension "smart_open"
    -- Telescope the most important files on the project as determined by telescope
    local map = vim.keymap.set
    map("n", "<leader>fc", function()
      require("telescope").extensions.smart_open.smart_open()
    end, { noremap = true, silent = true, desc = "Smart open of telescope files" })
    map("n", "<leader><leader>", function()
      require("telescope").extensions.smart_open.smart_open { cwd_only = true }
    end, { noremap = true, silent = true, desc = "Smart open of telescope files (within directory)" })
  end,
}

return {
  "Xouzoura/lyrics-in-buffer.nvim",
  -- dir = "/home/xouzoura/code/lua/me/lyrics",
  config = function()
    require("lyrics").setup {
      lyrics_fetcher_path = "~/code/python/me/lyrics",
    }
  end,

  keys = {
    {
      "<leader>sn",
      function()
        require("lyrics").get_current_song()
      end,
      desc = "<lyrics> Search what is playing now",
    },
  },
}

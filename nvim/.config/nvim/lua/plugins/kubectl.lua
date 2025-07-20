return {
  {
    "ramilito/kubectl.nvim",
    -- lazy = false,
    version = "2.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    dependencies = "saghen/blink.download",
    config = function()
      require("kubectl").setup()
      vim.keymap.set("n", "<leader>k8", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })
    end,
  },
}

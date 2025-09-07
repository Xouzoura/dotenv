-- return {}
-- check https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua
-- find solution for snippets, hotkeys etc
return {
  -- { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    -- dependencies = { "rafamadriz/friendly-snippets" },
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    lazy = false,

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- preset = "default",
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        -- ["<C-s>"] = { "snippet_forward", "fallback" },
        -- ["<C-d>"] = { "snippet_backward", "fallback" },

        -- Mine.
        ["<C-x>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-e>"] = { "select_and_accept" },
        ["<C-y>"] = { "select_and_accept" },
      },
      snippets = {
        preset = "luasnip",
      },
      appearance = {
        nerd_font_variant = "mono",
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false, -- Disable nvim-cmp
  },
}

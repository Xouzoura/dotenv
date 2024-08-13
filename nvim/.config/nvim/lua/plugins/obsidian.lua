-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*", -- recommended, use latest release instead of latest commit
--   -- lazy = false,
--   enabled = false,
--   ft = "markdown",
--   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
--   -- event = {
--   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
--   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
--   --   -- refer to `:h file-pattern` for more examples
--   --   "BufReadPre path/to/my-vault/*.md",
--   --   "BufNewFile path/to/my-vault/*.md",
--   -- },
--   dependencies = {
--     -- Required.
--     "nvim-lua/plenary.nvim",
--
--     -- see below for full list of optional dependencies 👇
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "~/vaults/personal",
--       },
--       {
--         name = "work",
--         path = "~/vaults/work",
--       },
--     },
--
--     -- see below for full list of options 👇
--   },
-- }
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = {
    "BufReadPre ~/vaults/personal/*.md",
    "BufNewFile ~/vaults/personal/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    -- Keymaps specified in keys can be used from anywhere
    -- Keymaps specified in opts can only be used when the plugin has been loaded
    {
      "<leader>md",
      function()
        vim.cmd "ObsidianToday"
      end,
      desc = "(Obsidian) Daily",
    },
    {
      "<leader>mn",
      function()
        local filename = vim.fn.input "Enter filename: "
        vim.cmd("ObsidianNew " .. filename)
      end,
      desc = "(Obsidian) New File",
    },
    {
      "<leader>mt",
      function()
        vim.cmd "ObsidianTags"
      end,
      desc = "(Obsidian) Tags",
    },
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        -- path = paths.obsidian.vault,
        path = "~/vaults/personal",
      },
    },
    daily_notes = {
      -- folder = paths.obsidian.daily,
      folder = "~/vaults/personal",
    },
    completion = {
      min_chars = 1,
    },
    mappings = {
      -- only with obsidian open they will appear
      --TODO: add mapping
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>mb"] = {
        action = function()
          vim.cmd "ObsidianBacklinks"
        end,
        opts = { desc = "(Obsidian) Backlinks" },
      },
      ["<leader>ml"] = {
        action = function()
          vim.cmd "ObsidianLinks"
        end,
        opts = { desc = "(Obsidian) Links" },
      },
      ["<leader>mo"] = {
        action = function()
          vim.cmd "ObsidianOpen"
        end,
        opts = { desc = "(Obsidian) Open in Obsidian app" },
      },
      ["<leader>mr"] = {
        action = function()
          vim.cmd "ObsidianRename"
        end,
        opts = { desc = "(Obsidian) Rename" },
      },
    },

    wiki_link_func = "use_alias_only",

    note_path_func = function(spec)
      local path = spec.dir / spec.title
      return path:with_suffix ".md"
    end,

    note_id_func = function(title)
      return title
    end,

    open_app_foreground = true,
  },
}

local picker = require "picker"
local telescope_enabled = not picker.USE_FZF_LUA
return {
  {
    -- TODO: deprecate the nvim-tree.lua changes since i don't use it.
    -- Plugin: nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    opts = function()
      local custom = require "nvchad.configs.nvimtree"
      -- Remove default keymaps and add new ones

      custom.filters.dotfiles = false
      custom.git = custom.git or {}
      custom.git.ignore = false

      -- Add custom highlighting configuration
      custom.renderer = custom.renderer or {}
      custom.renderer.highlight_opened_files = "all"
      custom.renderer.icons = custom.renderer.icons or {}
      custom.renderer.icons.show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      }
      -- Add actions configuration to disable window picker (A or B), I just want to open.
      custom.actions = custom.actions or {}
      custom.actions.open_file = custom.actions.open_file or {}
      custom.actions.open_file.window_picker = {
        enable = false,
      }
      -- Configure to update focus when entering a buffer
      custom.update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      }

      -- Add custom highlighting colors
      vim.cmd [[
          highlight NvimTreeOpenedFile guifg=#8e7cc3
          highlight NvimTreeCursorLine guibg=#b4a7d6
      ]]

      return custom
    end,
  },
  {
    -- Plugin: nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    enabled = telescope_enabled,
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function()
      local custom = require "nvchad.configs.telescope"
      if not picker.FZF_LUA_KEYS then
        local telescope = require "telescope"
        telescope.load_extension "live_grep_args"
        local lga_actions = require "telescope-live-grep-args.actions"
        local live_grep_args_shortcuts = require "telescope-live-grep-args.shortcuts"
        custom.defaults.mappings = {
          n = { ["q"] = require("telescope.actions").close, ["d"] = require("telescope.actions").delete_buffer },
        }
        -- Extend the custom configuration
        custom.extensions = custom.extensions or {}
        custom.extensions.live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
              ["<C-space>"] = require("telescope.actions").to_fuzzy_refine,
            },
          },
        }
        vim.keymap.set(
          "n",
          "<leader>fj",
          live_grep_args_shortcuts.grep_word_under_cursor,
          { noremap = true, silent = true, desc = "Telescope Live Grep Args (current word)" }
        )
        require("telescope").setup {
          extensions = {
            git = {
              -- Custom command for commits
              git_commits = function(opts)
                print "called"
                opts = opts or {}
                opts.formatter = function(entry)
                  local commit_date = entry.date:match "^(%d+-%d+-%d+ %d+:%d+:%d+)"
                  return string.format("%s %s", commit_date, entry.summary)
                end
                return require("telescope.builtin").git_commits(opts)
              end,
            },
          },
        }
      end
      return custom
    end,
  },
  -- More plugins
  {
    -- because nvchad doesn't load this plugin by default, so i don't need to press space two times
    "folke/which-key.nvim",
    lazy = false,
  },
}

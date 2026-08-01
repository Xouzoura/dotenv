return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require "nvim-treesitter-textobjects.select"
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"

      vim.keymap.set({ "x", "o" }, "aa", function()
        select.select_textobject("@parameter.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ia", function()
        select.select_textobject("@parameter.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ii", function()
        select.select_textobject("@conditional.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ai", function()
        select.select_textobject("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "il", function()
        select.select_textobject("@loop.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "al", function()
        select.select_textobject("@loop.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "at", function()
        select.select_textobject("@comment.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        move.goto_next_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end)

      -- swap
      vim.keymap.set("n", "<leader><", function()
        swap.swap_previous "@parameter.inner"
      end)
      vim.keymap.set("n", "<leader>>", function()
        swap.swap_next "@parameter.inner"
      end)
    end,
  },
}
-- return {
--   {
--     "nvim-treesitter/nvim-treesitter",
--     event = { "BufReadPost", "BufNewFile" },
--     cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
--     build = ":TSUpdate",
--     lazy = false,
--     opts = function()
--       return {
--         ensure_installed = { "lua", "luadoc", "printf", "vim", "vimdoc" },
--         highlight = {
--           enable = true,
--           use_languagetree = true,
--         },
--         indent = { enable = true },
--       }
--     end,
--     config = function(_, opts)
--       require("nvim-treesitter.configs").setup(opts)
--     end,
--   },
--   {
--     "nvim-treesitter/nvim-treesitter-textobjects",
--     dependencies = { "nvim-treesitter" },
--     lazy = false,
--     config = function()
--       require("nvim-treesitter.configs").setup {
--
--         -- Add languages to be installed here that you want installed for treesitter
--         ensure_installed = {
--           "python",
--           "bash",
--           "hurl",
--           "rust",
--         },
--
--         highlight = { enable = true },
--         indent = { enable = true },
--         incremental_selection = {
--           enable = true,
--           keymaps = {
--             -- decided for s-l and s-h since i don't use them
--             init_selection = "<s-l>",
--             node_incremental = "<s-l>",
--             node_decremental = "<s-h>",
--           },
--         },
--         textobjects = {
--           select = {
--             enable = true,
--             lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--             keymaps = {
--               -- You can use the capture groups defined in textobjects.scm
--               ["aa"] = "@parameter.outer",
--               ["ia"] = "@parameter.inner",
--               ["af"] = "@function.outer",
--               ["if"] = "@function.inner",
--               ["ac"] = "@class.outer",
--               ["ic"] = "@class.inner",
--               ["ii"] = "@conditional.inner",
--               ["ai"] = "@conditional.outer",
--               ["il"] = "@loop.inner",
--               ["al"] = "@loop.outer",
--               ["at"] = "@comment.outer",
--             },
--           },
--           move = {
--             enable = true,
--             set_jumps = true, -- whether to set jumps in the jumplist
--             goto_next_start = {
--               ["]f"] = "@function.outer",
--               ["]c"] = "@class.outer",
--             },
--             goto_next_end = {
--               ["]F"] = "@function.outer",
--               ["]C"] = "@class.outer",
--             },
--             goto_previous_start = {
--               ["[f"] = "@function.outer",
--               ["[c"] = "@class.outer",
--             },
--             goto_previous_end = {
--               ["[F"] = "@function.outer",
--               ["[C"] = "@class.outer",
--             },
--           },
--           swap = {
--             enable = true,
--             swap_previous = {
--               ["<leader><"] = "@parameter.inner",
--             },
--             swap_next = {
--               ["<leader>>"] = "@parameter.inner",
--             },
--           },
--         },
--       }
--     end,
--   },
-- }

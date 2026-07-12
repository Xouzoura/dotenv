-- return {
--   "obsidian-nvim/obsidian.nvim",
--   version = "*", -- use latest release
--   lazy = true,
--   ft = "markdown", -- or event-based loading, see below
--   ---@module 'obsidian'
--   ---@type obsidian.config
--   opts = {
--     legacy_commands = false,
--     workspaces = {
--       { name = "personal", path = "~/vaults/personal" },
--     },
--   },
-- }
return {
  "obsidian-nvim/obsidian.nvim",
  -- lazy = false,
  ft = "markdown", -- or event-based loading, see below
  dependencies = { "ibhagwan/fzf-lua" },
  event = {
    "BufReadPre ~/vaults/*.md",
    "BufNewFile ~/vaults/*.md",
  },

  keys = {
    {
      "<leader>mn",
      function()
        local filename = vim.fn.input "Enter filename: "
        vim.cmd("Obsidian new " .. filename)
      end,
      desc = "(Obsidian) New File",
    },
    {
      "<leader>mt",
      function()
        vim.cmd "Obsidian tags"
      end,
      desc = "(Obsidian) Tags",
    },
    {
      "<leader>mo",
      function()
        vim.cmd "Obsidian search"
      end,
      desc = "(Obsidian) Search",
    },
    {
      "<leader>m;",
      mode = { "n", "x", "v" },
      function()
        vim.cmd "Obsidian toggle_checkbox"
      end,
      desc = "(Obsidian) Check",
    },
    {
      "<leader>mf",
      function()
        vim.cmd "Obsidian follow_link"
      end,
      desc = "(Obsidian) Go to the link",
    },
    {
      "<leader>mb",
      function()
        vim.cmd "Obsidian backlinks"
      end,
      desc = "(Obsidian) Find the backlinks",
    },
    {
      "<leader>ml",
      function()
        vim.cmd "Obsidian links"
      end,
      desc = "(Obsidian) Find buffer links",
    },
    {
      "<leader>mww",
      function()
        vim.cmd "e ~/vaults/notes/_work.md"
      end,
      desc = "(Obsidian) Open work",
    },
    {
      "<leader>mwd",
      function()
        vim.cmd "e ~/vaults/notes/_daily.md"
      end,
      desc = "(Obsidian) Open my daily",
    },
  },
  opts = {
    picker = {
      name = "fzf-lua",
    },
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "no-vault",
        path = function()
          return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
          notes_subdir = vim.NIL,
          new_notes_location = "current_dir",
          templates = {
            folder = vim.NIL,
          },
        },
      },
      -- {
      --   name = "work",
      --   path = "~/vaults/work",
      -- },
    },
    notes_subdir = "notes",
    completion = {
      min_chars = 2,
    },
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end

      return os.date "%Y-%m-%d" .. "_" .. suffix
    end,
    link = {
      style = "wiki",
      format = "shortest",
      auto_update = false,
    },
    legacy_commands = false,

    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkbox = {
        order = { " ", "~", "!", ">", "x" },
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
  },
}

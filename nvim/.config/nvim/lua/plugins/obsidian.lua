return {
  "epwalsh/obsidian.nvim",
  version = "*",
  -- lazy = false,
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
      "<leader>mx",
      function()
        vim.cmd "ObsidianOpen"
      end,
      desc = "(Obsidian) Open in Obsidian app",
    },
    {
      "<leader>mt",
      function()
        vim.cmd "ObsidianTags"
      end,
      desc = "(Obsidian) Tags",
    },
    {
      "<leader>mo",
      function()
        vim.cmd "ObsidianSearch"
      end,
      desc = "(Obsidian) Search",
    },
    {
      "<leader>m;",
      function()
        vim.cmd "ObsidianToggleCheckbox"
      end,
      desc = "(Obsidian) Check",
    },
    {
      "<leader>mf",
      function()
        vim.cmd "ObsidianFollowLink"
      end,
      desc = "(Obsidian) Go to the link",
    },
    {
      "<leader>mb",
      function()
        vim.cmd "ObsidianBacklinks"
      end,
      desc = "(Obsidian) Find the backlinks",
    },
    {
      "<leader>ml",
      function()
        vim.cmd "ObsidianLinks"
      end,
      desc = "(Obsidian) Find buffer links",
    },
    {
      "<leader>mg",
      function()
        vim.cmd "e ~/vaults/notes/_daily.md"
      end,
      desc = "(Obsidian) Open daily notes (global)",
    },
    {
      "<leader>ms",
      function()
        vim.cmd "e ~/vaults/notes/"
      end,
      desc = "(Obsidian) Open workspace files",
    },
    {
      "<leader>mww",
      function()
        vim.cmd "e ~/vaults/notes/_work.md"
      end,
      desc = "(Obsidian) Open work",
    },
  },
  opts = {

    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
    },
    daily_notes = {
      folder = "daily",
    },
    notes_subdir = "notes",
    completion = {
      min_chars = 1,
    },
    mappings = {
      -- only with obsidian open they will appear
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
      ["<leader>mr"] = {
        action = function()
          vim.cmd "ObsidianRename"
        end,
        opts = { desc = "(Obsidian) Rename" },
      },
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
    wiki_link_func = "use_alias_only",

    -- note_path_func = function(spec)
    --   local path = spec.dir / spec.title
    --   return path:with_suffix ".md"
    -- end,
    --
    -- note_id_func = function(title)
    --   return title
    -- end,

    open_app_foreground = true,
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
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

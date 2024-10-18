return {
  -- Install markdown preview, use npx if available.
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  ft = { "markdown" },
  -- ft = { "markdown" },
  -- build = function(plugin)
  --   if vim.fn.executable "npx" then
  --     vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
  --   else
  --     vim.cmd [[Lazy load markdown-preview.nvim]]
  --     vim.fn["mkdp#util#install"]()
  --   end
  -- end,
  -- init = function()
  --   if vim.fn.executable "npx" then
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end
  -- end,
}
-- return {
--   -- Preview of any Markdown with :MarkdownPreview
--   "iamcco/markdown-preview.nvim",
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--   ft = { "markdown" },
--   build = function()
--     vim.fn["mkdp#util#install"]()
--   end,
-- }

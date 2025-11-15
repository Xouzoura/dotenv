---@diagnostic disable: undefined-global

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        extraPaths = {},
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        cacheLibraryFiles = true, -- Speeds up library lookups
        indexing = true, -- Enables background indexing
        diagnosticMode = "openFilesOnly",
        -- diagnosticMode = "workspace", -- works for all open files
        typeCheckingMode = "basic",
        excludePaths = { "**/.venv/**", "**/.git/**" },
      },
    },
  },
})
local servers = { "html", "cssls", "clangd", "lua_ls", "ts_ls", "angularls", "taplo", "pyright" }
-- local servers = { "html", "clangd", "taplo", "pyright" } -- simpler
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

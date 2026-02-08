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

-- <PICK SERVERS> --

-- 1) old with pyright
-- local servers = { "html", "cssls", "clangd", "lua_ls", "ts_ls", "angularls", "taplo", "pyright", "csharp_ls"} -- pyright
-- 2) experimental with ty
local servers = { "html", "cssls", "clangd", "lua_ls", "ts_ls", "angularls", "taplo", "csharp_ls", "ty" } -- ty
-- 3) super basic with pyright
-- local servers = { "html", "clangd", "taplo", "pyright" } -- simpler

-- << enable server >>
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

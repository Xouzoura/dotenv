---@diagnostic disable: undefined-global

-- custom configs
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

-- underdevelopment

-- <PICK SERVERS> --

local servers = {
  ---- >> frontend <<
  "html",
  "cssls",
  "ts_ls",
  "angularls",
  ---- >> backend <<
  "bashls",
  "clangd",
  "lua_ls",
  "gopls",
  "csharp_ls",
  ---- >> backend (python) <<
  -- <combo1>
  "ty",
  "ruff",
  -- <combo2>
  -- "pyright",
  -- <combo3>
  -- "pyrefly",
  ---- >> IaaC and others <<
  "yaml-language-server",
  "taplo",
  "terraformls",
}
-- 3) super basic with pyright
-- local servers = { "html", "clangd", "taplo", "pyright" } -- simpler

-- << enable server >>
for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

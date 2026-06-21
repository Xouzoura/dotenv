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
vim.lsp.config("ty", {
  settings = {
    ty = {
      configuration = {
        rules = {
          ["unresolved-import-test"] = "error",
          ["unresolved-import"] = "error",
          ["possibly-unresolved-reference"] = "error",
          ["division-by-zero"] = "error",
          -- ["undefined-local-with-import-star-usage"] = "error",
          -- ["unresolved-reference"] = "warn",
        },
        analysis = {
          ["unresolved-import"] = "error",
          --   -- ["undefined-local-with-import-star-usage"] = "error",
          --   -- ["unresolved-reference"] = "warn",
        },
      },
    },
  },
})

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
  -- "ty",
  -- "pyright",
  "pyrefly",
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

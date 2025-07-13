local on_attach = function(client, bufnr)
  -- Override nvchad to disable the signature help
  local _nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
  if _nvchad_on_attach then
    _nvchad_on_attach(client, bufnr)
  end
  -- client.server_capabilities.signatureHelpProvider = false
end
-- local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"
-- My default servers are for
-- C, Angular (+TS), Python, Rust, Lua
local servers = { "html", "cssls", "clangd", "lua_ls", "ts_ls", "angularls" }
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Non-defaults
-- pyright
lspconfig.pyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
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
}

-- Rust uses the rustaceanvim lazy plugin.
-- (skipping)
--
-- c#
--
-- Setup OmniSharp manually, currently sucks
-- lspconfig.omnisharp.setup {
--   cmd = { "OmniSharp" },
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
--   enable_editorconfig_support = true,
--   enable_ms_build_load_projects_on_demand = false,
--   enable_roslyn_analyzers = false,
--   organize_imports_on_format = false,
--   enable_import_completion = false,
--   sdk_include_prereleases = true,
--   analyze_open_documents_only = false,
-- }

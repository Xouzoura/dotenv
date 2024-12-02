local on_attach = function(client, bufnr)
  -- Override nvchad to disable the signature help
  local _nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
  if _nvchad_on_attach then
    _nvchad_on_attach(client, bufnr)
  end
  client.server_capabilities.signatureHelpProvider = false
end
-- local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "clangd", "lua_ls" }
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Non-defaults
-- PYTHON (.venv exclusion)
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
        diagnosticMode = "workspace",
        typeCheckingMode = "basic",
        excludePaths = { "**/.venv/**" },
      },
    },
  },
}

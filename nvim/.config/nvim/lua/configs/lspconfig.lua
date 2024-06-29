-- BEFORE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {"html", "cssls", "pyright", "tsserver", "clangd"}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- New
-- local configs = require "nvchad.configs.lspconfig"
--
-- local servers = {
--   html = {},
--   awk_ls = {},
--   bashls = {},
--   clangd = {},
--   pyright = {
--     settings = {
--       python = {
--         analysis = {
--           autoSearchPaths = true,
--           typeCheckingMode = "basic",
--         },
--       },
--     },
--   },
-- }
--
-- for name, opts in pairs(servers) do
--   opts.on_init = configs.on_init
--   opts.on_attach = configs.on_attach
--   opts.capabilities = configs.capabilities
--
--   require("lspconfig")[name].setup(opts)
-- end

return {
  -- plugin to show how can times a symbol is referenced
  "VidocqH/lsp-lens.nvim",
  -- "Xouzoura/lsp-lens.nvim",
  -- branch = "main",
  -- branch = "feature/add-methods-of-class",
  -- dir = "/home/xouzoura/python/me/openai/lua/lsp-lens.nvim",
  lazy = false,
  config = function()
    local SymbolKind = vim.lsp.protocol.SymbolKind
    require("lsp-lens").setup {
      enable = true,
      include_declaration = false, -- Reference include declaration
      sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
        definition = false,
        references = function(count)
          return "...RefCount: [" .. count .. "]"
        end,
        -- references = true,
        implements = true,
        git_authors = false,
      },
      ignore_filetype = {
        "prisma",
      },
      -- Target Symbol Kinds to show lens information
      target_symbol_kinds = {
        SymbolKind.Function,
        SymbolKind.Class,
        SymbolKind.Method,
        SymbolKind.Interface,
        SymbolKind.Object, -- added now
      },
      -- Symbol Kinds that may have target symbol kinds as children
      wrapper_symbol_kinds = { SymbolKind.Struct, SymbolKind.Class, SymbolKind.Object }, -- Works for python better
      -- wrapper_symbol_kinds = { SymbolKind.Struct }, -- works for Rust better
    }
  end,
}

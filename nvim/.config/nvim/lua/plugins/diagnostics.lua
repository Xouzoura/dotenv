return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  enabled = false, -- disabled since it causes LOTS of issues at the moment in oil and other plugins.
  config = function()
    vim.diagnostic.config { virtual_text = false, severity_sort = true, signs = true }

    require("tiny-inline-diagnostic").setup {

      preset = "classic",
      options = {
        show_all_diags_on_cursorline = false,
        multilines = true,
        format = function(diagnostic)
          local code = diagnostic.code or ""
          if code == "" then
            return diagnostic.message
          end
          return diagnostic.message .. " [" .. code .. "]"
        end,
      },
    }
  end,
}

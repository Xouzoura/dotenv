
local M = {}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"},
    ["<leader>dc"] = {"<cmd> DapContinue <CR>"},
    ["<leader>ds"] = {"<cmd> DapTerminate <CR>"},
    ["<leader>dr"] = {"<cmd> DapRestart <CR>"},
    -- Only UI
    ["<leader>dq"] = {"lua require('dapui').open({reset=true})<CR>"},
    ["<leader>dt"] = {"<cmd> DapUiToggle <CR>"},
    ["<leader>dv"] = {"<cmd> DapVirtualTextToggle <CR>"},

  }
}
M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function ()
        require('dap-python').test_method()
      end
    }
  }
}
return M

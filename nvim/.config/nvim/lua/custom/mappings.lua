local M = {}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
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
M.custom = {
  n = {
    ["<leader>q"] = {"<cmd>bp<bar>sp<bar>bn<bar>bd<CR>"}
  }
}
return M

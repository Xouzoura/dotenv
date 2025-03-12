return {
  -- Default fold
  "kevinhwang91/nvim-ufo",
  event = "BufEnter",
  dependencies = {
    "kevinhwang91/promise-async",
    -- Second dependency is to remove the useless numbers on the side.
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require "statuscol.builtin"
        require("statuscol").setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            { text = { "%s" }, click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          },
        }
      end,
    },
  },

  config = function()
    require("ufo").setup {
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        c = { "comment", "region" },
      },
      open_fold_hl_timeout = 0,
      provider_selector = function(_, filetype)
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local _start = lnum - 1
        local _end = end_lnum - 1
        local start_text = vim.api.nvim_buf_get_text(0, _start, 0, _start, -1, {})[1]
        local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
        return start_text .. " ⋯ " .. final_text .. (" 󰁂 %d "):format(end_lnum - lnum)
      end,
    }
    -- Mapping
    -- 0
    vim.keymap.set("n", "z0", function()
      vim.wo.foldlevel = 0
      print "Fold level: 0" -- Display the new fold level
    end, { desc = "Set fold to 0" })

    -- 1
    vim.keymap.set("n", "z1", function()
      vim.wo.foldlevel = 1
      print "Fold level: 1" -- Display the new fold level
    end, { desc = "Set fold to 1" })

    vim.keymap.set("n", "z2", function()
      vim.wo.foldlevel = 2
      print "Fold level: 2" -- Display the new fold level
    end, { desc = "Set fold to 2" })
    -- max
    vim.keymap.set("n", "z=", function()
      vim.wo.foldlevel = 20
      print "Fold level: 20" -- Display the new fold level
    end, { desc = "Set fold to max" })
    -- decrease
    vim.keymap.set("n", "z-", function()
      local current_level = vim.wo.foldlevel
      vim.wo.foldlevel = math.max(current_level - 1, 0) -- Ensure it doesn't go below 0
      print("Fold level: " .. vim.wo.foldlevel) -- Display the new fold level
    end, { desc = "Decrease fold level" })

    -- increase
    vim.keymap.set("n", "z+", function()
      local current_level = vim.wo.foldlevel
      vim.wo.foldlevel = current_level + 1
      print("Fold level: " .. vim.wo.foldlevel) -- Display the new fold level
    end, { desc = "Increase fold level" })

    -- Hover and sneak-peek
    vim.keymap.set("n", "zp", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- choose one of coc.nvim and nvim lsp
        -- vim.fn.CocActionAsync('definitionHover') -- coc.nvim
        vim.lsp.buf.hover()
      end
    end)
  end,
}

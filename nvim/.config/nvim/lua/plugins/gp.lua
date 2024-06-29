
return {
    -- chatgpt in the nvim config
    "robitx/gp.nvim",
    lazy=false,
    config = function()
        local config = require("configs.gp-config")
        require("gp").setup(config)
    end,
}


-- return {
--     -- Ai copilot
--     'github/copilot.vim',
--     lazy=false
-- }
return {
    "Exafunction/codeium.nvim",
    lazy=false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
        })
    end
}

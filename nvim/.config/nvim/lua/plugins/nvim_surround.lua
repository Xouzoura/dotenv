
return {
    -- ysiw" to surround the word with "
    -- ds" to remove the surrounding"
    -- cs"' to change the surrounding to '
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
        })
    end
}

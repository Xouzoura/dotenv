
return {
    -- Autocomplete with tab for the cmd
    'gelguy/wilder.nvim',
    lazy=false,
    dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/nvim-cmp',
    },
    -- after = "nvim-cmp",
    config = function()
        require("wilder").setup({
            modes = {"/"}
        })
    end,
}


return {
    -- Go to preview a specific row when typing :32 without actually going there
    'nacro90/numb.nvim',
    lazy=false,
    config = function()
        require('numb').setup()
    end
}

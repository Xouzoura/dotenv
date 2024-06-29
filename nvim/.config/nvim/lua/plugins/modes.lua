
return {
    -- Color highlither for different modes (insert, normal, visual, etc)
    'mvllow/modes.nvim',
    lazy=false,
    tag = 'v1.2.0',
    config = function()
        require('modes').setup()
    end
}

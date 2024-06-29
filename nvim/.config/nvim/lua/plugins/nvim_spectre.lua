
return {
    -- Search and replace within all the files
    'nvim-pack/nvim-spectre',
    config=function ()
        require('spectre').setup({
            -- mapping space + S, sw, sp,
            result_padding = '',
            default = {
                replace = {
                    cmd = "sed"
                }
            }
        })
    end
}

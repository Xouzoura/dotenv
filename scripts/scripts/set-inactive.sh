#!/bin/bash  
  
pane_command=$(tmux display-message -p '#{pane_current_command}')  
if [ "$pane_command" = "nvim" ]; then  
    if [ -n "$1" ] && [ "$1" = true ]; then 
        tmux send-keys ':' 'setlocal winhighlight=Normal:ActiveWindow' Enter  
        #tmux send-keys ':' 'lua if vim.fn.mode() == "n" then vim.cmd("setlocal winhighlight=Normal:ActiveWindow") end' Enter
        # tmux send-keys ':' 'lua SetWindowHighlight(true)' Enter
    else
        tmux send-keys ':' 'setlocal winhighlight=Normal:InactiveWindow' Enter  
        #tmux send-keys ':' 'lua if vim.fn.mode() == "n" then vim.cmd("setlocal winhighlight=Normal:InactiveWindow") end' Enter
        # tmux send-keys ':' 'lua SetWindowHighlight(false)' Enter
    fi
    tmux send-keys ':' 'echo ""' Enter
fi  

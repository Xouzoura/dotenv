#!/bin/bash  
  
pane_command=$(tmux display-message -p '#{pane_current_command}')  
if [ "$pane_command" = "nvim" ]; then  
    if [ -n "$1" ] && [ "$1" = true ]; then 
        tmux send-keys ':' 'setlocal winhighlight=Normal:ActiveWindow' Enter  
    else
        tmux send-keys ':' 'setlocal winhighlight=Normal:InactiveWindow' Enter  
    fi
    tmux send-keys ':' 'echo ""' Enter
fi  

# --------- OLD CODE THAT SWITCHES TO LAST PANE ---------------
# # Switch to last pane  
# tmux select-pane -l  
#
# pane_command=$(tmux display-message -p '#{pane_current_command}')  
#
# if [ "$pane_command" = "nvim" ]; then  
#     tmux send-keys ':' 'setlocal winhighlight=Normal:InactiveWindow' Enter  
#     tmux send-keys ':' 'echo ""' Enter
# fi  
#
# # Switch to last pane    
# tmux select-pane -l
# pane_command=$(tmux display-message -p '#{pane_current_command}')    
#
# if [ "$pane_command" = "nvim" ]; then    
#     # If nvim is running, execute the command to make it Active  
#     tmux send-keys ':' 'setlocal winhighlight=Normal:ActiveWindow' Enter  
#     tmux send-keys ':' 'echo ""' Enter
# fi    

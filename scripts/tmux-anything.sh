#!/bin/bash

SESSION_NAME="anything"

echo "Starting tmux session: $SESSION_NAME"
# Check if the session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
  # If the session does not exist, create a new session
  tmux new-session -s $SESSION_NAME -d
fi

# Attach to the session
tmux attach-session -t $SESSION_NAME

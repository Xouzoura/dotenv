#!/bin/bash
current_dir=$(pwd)
cd ..

# Check if either venv or venv3.11 directory exists
# # Check in the current directory
if [ -d "venv3.11" ]; then
    echo "Activating the venv3.11"
    source venv3.11/bin/activate
elif [ -d "venv" ]; then
    echo "Activating the venv"
    source venv/bin/activate
elif [ -d ".venv" ]; then
    echo "Activating the venv"
    source .venv/bin/activate
elif [ -d "../venv3.11" ]; then
    echo "Activating the ../venv3.11"
    source ../venv3.11/bin/activate
elif [ -d "../venv" ]; then
    echo "Activating the ../venv"
    source ../venv/bin/activate
# Check in the parent of the parent directory
elif [ -d "../../venv3.11" ]; then
    echo "Activating the ../../venv3.11"
    source ../../venv3.11/bin/activate
elif [ -d "../../venv" ]; then
    echo "Activating the ../../venv"
    source ../../venv/bin/activate
elif [ "$1" = "0" ]; then
    # Create virtual environment if 0 is provided as input
    virtualenv venv
    source venv/bin/activate
else
    echo "Error: No virtual environment found in current directory or parent directories."
    # exit 1
fi
echo $(which python)
# Return to original directory
cd "$current_dir"

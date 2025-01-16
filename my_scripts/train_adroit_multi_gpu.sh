#!/bin/bash

# Usage: bash my_scripts/train_adroit_multi_gpu.sh <task_name> <num_episodes> <gpu_id1> <gpu_id2> <gpu_id3>
# Example: bash my_scripts/train_adroit_multi_gpu.sh hammer 50 0 1 2

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <task_name> <num_episodes> <gpu_id1> <gpu_id2> <gpu_id3>"
    echo "Example: $0 hammer 50 0 1 2"
    exit 1
fi

task_name=$1
num_episodes=$2
gpu_id1=$3
gpu_id2=$4
gpu_id3=$5

# Check if tmux session exists and kill it if it does
session_name="train_${task_name}"
tmux kill-session -t ${session_name} 2>/dev/null

# Generate demonstrations first using the specified GPU
echo "Generating demonstrations for ${task_name} with ${num_episodes} episodes on GPU ${gpu_id1}..."
export CUDA_VISIBLE_DEVICES=${gpu_id1}
bash scripts/gen_demonstration_adroit.sh ${task_name} ${num_episodes}

# Function to create training command
get_train_cmd() {
    local seed=$1
    local gpu_id=$2
    echo "conda activate dp3 && bash scripts/train_policy.sh dp3 adroit_${task_name} 0322 ${seed} ${gpu_id} ${num_episodes}"
}

# Create new tmux session for each training run
tmux new-session -d -s ${session_name}

# Split the window into three panes
tmux split-window -h -t ${session_name}
tmux split-window -h -t ${session_name}

# Send commands to each pane
tmux send-keys -t ${session_name}.0 "$(get_train_cmd 0 ${gpu_id1})" C-m
tmux send-keys -t ${session_name}.1 "$(get_train_cmd 1 ${gpu_id2})" C-m
tmux send-keys -t ${session_name}.2 "$(get_train_cmd 2 ${gpu_id3})" C-m

echo "Training started in tmux session '${session_name}'"
echo "To attach to the session, use: tmux attach-session -t ${session_name}" 
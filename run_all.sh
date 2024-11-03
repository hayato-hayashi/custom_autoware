#!/bin/bash

# Function to kill all background jobs on exit
cleanup() {
  echo "Stopping all background jobs..."
  # Kill all background jobs
  for pid in "${pids[@]}"; do
    kill "$pid"
  done
  exit
}

# Trap SIGINT (Ctrl+C) and call cleanup
trap cleanup SIGINT

# Run the first static transform publisher from map to odom
ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map odom &
pids[0]=$!

# Run the second static transform publisher from odom to base_link
ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 odom base_link &
pids[1]=$!

# Run rqt_runtime_monitor
ros2 run rqt_runtime_monitor rqt_runtime_monitor &
pids[2]=$!

# Wait for all background jobs to complete
wait

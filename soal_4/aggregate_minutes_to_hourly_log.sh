#!/bin/bash

# Determine the current user's home directory
user_home=$(getent passwd "$(whoami)" | cut -d: -f6)

# Define the path to the log file in the user's home directory
log_file="$user_home/log/metrics_agg_$(date +'%Y%m%d%H%M%S').log"

# Execute the commands to retrieve system metrics
mem_metrics=$(free -m | grep Mem | awk '{print $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8}')
swap_metrics=$(free -m | grep Swap | awk '{print $2 "," $3 "," $4}')
path="/home/chyldmoeleister/log/"
path_size=$(du -sh "$path" | cut -f1)

# Write the metrics to the log file
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "minimum,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
echo "maximum,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"
echo "average,$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"

# Set permissions so that only chyldmoeleister can access the log file
chmod 600 "$log_file"

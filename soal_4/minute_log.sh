#!/bin/bash

# Define the log file path
log_file="/home/chyldmoeleister/log/metrics_$(date +'%Y%m%d%H%M%S').log"

# Execute the commands to retrieve system metrics
mem_metrics=$(free -m | grep Mem | awk '{print $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8}')
swap_metrics=$(free -m | grep Swap | awk '{print $2 "," $3 "," $4}')
path="/home/chyldmoeleister/log/"
path_size=$(du -sh "$path" | cut -f1)

# Write the metrics to the log file
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > "$log_file"
echo "$mem_metrics,$swap_metrics,$path,$path_size" >> "$log_file"

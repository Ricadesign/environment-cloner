#!/bin/bash

# Check if the correct argument was passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <connection_string>"
    exit 1
fi

# Read the argument
connection_string="$1"
CSV_FILE="data.csv"

# Read connection data from CSV
# Read CSV and assign variables
IFS=',' read -r name source_server source_user source_password source_database source_path destination_server destination_user destination_password destination_database destination_path < <(awk -F',' -v name="$connection_string" '$1 == name' "$CSV_FILE")

# Check if the name was found
if [ -z "$name" ]; then
    echo "Connections available:"
    awk -F ',' 'NR>1 {print $1}' "$CSV_FILE"
    exit 1
fi

# Output the connection data
echo "$name $source_server $source_user $source_password $source_database $source_path $destination_server $destination_user $destination_password $destination_database $destination_path"

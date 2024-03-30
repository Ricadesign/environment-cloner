#!/bin/bash

# Check if the correct arguments were passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <csv_file> <connection_string>"
    exit 1
fi

# Read the arguments
CSV_FILE="$1"
connection_string="$2"

# Read connection data from CSV
connection_data=$(grep "$connection_string" "$CSV_FILE")

# Check if connection data was found
if [ -z "$connection_data" ]; then
    exit 1
fi

# Read connection data from CSV
IFS=',' read -r name source_server source_user source_path destination_server destination_user destination_path <<< "$connection_data"

# Output the connection data
echo "$name $source_server $source_user $source_path $destination_server $destination_user $destination_path"

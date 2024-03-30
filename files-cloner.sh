#!/bin/bash

# Verify if the correct argument was passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <connection_string>"
    exit 1
fi

# Assign the arguments to variables
CSV_FILE="data.csv"
connection_string="$1"

read -r name source_server source_user source_path destination_server destination_user destination_path <<< $(./data-reader.sh "$CSV_FILE" "$connection_string")

# Copy files from the source server to the local folder
echo "Copying files from $source_path on $source_server to ./copy..."
rsync -avz -e ssh "$source_user@$source_server:$source_path/" "./copy/"

# Check the status of the local copy operation
if [ $? -ne 0 ]; then
    echo "Error: Unable to copy files from $source_server."
    exit 1
fi

# Clone files from the local folder to the destination server
echo "Cloning files from ./copy on the source server to $destination_path on $destination_server..."
rsync -avz -e ssh "./copy/" "$destination_user@$destination_server:$destination_path/"

rm -rf "./copy/"

# Check the status of the cloning operation
if [ $? -ne 0 ]; then
    echo "Error: Unable to clone files to $destination_server."
    exit 1
fi

echo "File cloning successful."

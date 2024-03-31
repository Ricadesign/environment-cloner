#!/bin/bash

# Verify if the correct argument was passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <connection_string>"
    exit 1
fi

# Assign the arguments to variables
connection_string="$1"

# Invoke the data-reader script to get connection data
connection_data=$(./data-reader.sh "$connection_string")

# Check if connection data was found
if [ $? -ne 0 ]; then
    echo "Error: Unable to retrieve connection data."
    echo $connection_data
    exit 1
fi

# Read connection data from the output of the data-reader script
read -r name source_server source_user source_password source_database source_path destination_server destination_user destination_password destination_database destination_path <<< "$connection_data"

# Create a backup directory on the destination server
echo "Creating backup directory on $destination_server..."
ssh "$destination_user@$destination_server" "cp -r $destination_path $destination_path/../public_backup"

# Check the status of creating the backup directory
if [ $? -ne 0 ]; then
    echo "Error: Unable to create backup directory on $destination_server."
    exit 1
fi

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

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

# Export database from source server
echo "Exporting database from $source_database on $source_server..."
ssh "$source_user@$source_server" "mysqldump -u$source_user -p'$source_password' $source_database > dump_origin.sql"

# Copy database dump to destination server
echo "Copying database dump to $destination_server..."
scp "$source_user@$source_server:~/dump_origin.sql" "$destination_user@$destination_server:~/dump_destination.sql"

# Check the status of the database dump copy operation
if [ $? -ne 0 ]; then
    echo "Error: Unable to copy database dump to $destination_server."
    exit 1
fi

# Import database dump to destination server
echo "Importing database dump to $destination_database on $destination_server..."
ssh "$destination_user@$destination_server" "mysql -u$destination_user -p'$destination_password' $destination_database < ~/dump_destination.sql"

# Check the status of the database import operation
if [ $? -ne 0 ]; then
    echo "Error: Unable to import database dump to $destination_server."
    exit 1
fi

# Remove database dump from source server
echo "Removing database dump from $source_server..."
ssh "$source_user@$source_server" "rm -f ~/dump_origin.sql"

# Remove database dump from destination server
echo "Removing database dump from $destination_server..."
ssh "$destination_user@$destination_server" "rm -f ~/dump_destination.sql"

echo "Database cloning successful."
#!/bin/bash

# Verify if the correct argument was passed
if [ "$#" -ne 8 ]; then
    echo "Usage: $0 <source_server> <source_user> <source_password> <source_database> <destination_server> <destination_user> <destination_password> <destination_database>"
    exit 1
fi

# Assign the arguments to variables
source_server="$1"
source_user="$2"
source_password="$3"
source_database="$4"
destination_server="$5"
destination_user="$6"
destination_password="$7"
destination_database="$8"

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
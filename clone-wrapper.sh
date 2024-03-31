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

# Execute the first script to export and import the database
./file-cloner.sh "$source_server" "$source_user" "$source_path" "$destination_server" "$destination_user" "$destination_path"

# Check the status of the first script execution
if [ $? -ne 0 ]; then
    echo "Error: Failed clone files."
    exit 1
fi

# Execute the second script to clone files
./db-cloner.sh "$source_server" "$source_user" "$source_password" "$source_database" "$destination_server" "$destination_user" "$destination_password" "$destination_database"

# Check the status of the second script execution
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone database."
    exit 1
fi

echo "Congratulations! Cloning process successful."
## Environment Cloner

This repository contains scripts to facilitate the cloning of files and databases between servers. The main script orchestrates the execution of two sub-scripts: one for cloning files and another for cloning databases.

## Prerequisites

Before running the scripts, ensure that you have the following prerequisites:

- SSH access to both source and destination servers.
- Proper permissions to execute the script.
```bash
chmod +x clone-wrapper.sh
```
- Properly formatted `data.csv` file containing connection details

### Usage

```bash
./clone-wrapper.sh <connection_string>
```

### Description

The clonse-wrapper.sh script orchestrates the cloning process by invoking the file-cloner.sh and db-cloner.sh scripts. It takes a connection string as an argument, retrieves connection data using a data-reader script, and then executes the file cloning and database cloning scripts with the appropriate parameters.

The file-cloner.sh script is responsible for cloning files between servers. It requires the source server, source user, source path, destination server, destination user, and destination path as arguments. It creates a backup directory on the destination server, copies files from the source server to a local folder, and then clones the files from the local folder to the destination server.

The db-cloner.sh script is responsible for cloning databases between servers. It requires the source server, source user, source password, source database, destination server, destination user, destination password, and destination database as arguments. It exports the database from the source server, copies the database dump to the destination server, imports the database dump into the destination database, and then removes the database dump files from both servers.

### Example

```bash
./clone-wrapper.sh my_connection
```

## Disclaimer

Ensure that the CSV file (`data.csv`) is correctly formatted with the required connection details. Any errors or issues with the connection details may result in failures during the file cloning process.

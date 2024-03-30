## File Cloning Script

This Bash script facilitates the cloning of files between two servers based on a provided connection string.

### Usage

```bash
./clone_files.sh <connection_string>
```

### Description

The script takes a single argument, `<connection_string>`, which represents the identifier for the desired connection details. It retrieves the necessary connection information from a CSV file (`data.csv`) using a helper script (`data-reader.sh`). The connection details include source and destination server addresses, user credentials, and file paths.

After validating the provided argument, the script proceeds to copy files from the source server to a local folder (`./copy`). It then clones these files from the local folder to the destination server. Upon successful completion, the local copy is removed.

### Example

```bash
./clone_files.sh my_connection
```

### Requirements

- Bash shell
- Properly formatted `data.csv` file containing connection details

## Disclaimer

Ensure that the CSV file (`data.csv`) is correctly formatted with the required connection details. Any errors or issues with the connection details may result in failures during the file cloning process.

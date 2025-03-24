# filesync
A Bash script for safe file synchronization between local and remote systems using rsync. Supports push (local → remote) and pull (remote → local) operations with interactive prompts to confirm deletions. Configurable via a separate config file for easy host management.

## Features
- Two-way sync: Push files to a remote host or pull files to your local machine.
- Safety checks: Prompts before deleting files to prevent accidental data loss.
- Config-driven: Manage hosts and directories in a simple config file.
- Uses rsync for efficient and reliable file transfers.


## Requirements
- rsync installed
- SSH access to remote system
- Write permission to destination folder. 

## Usage
Run the script via an alias (filesync) with one of the following options:

```
filesync push     # Sync local directory to remote
filesync pull     # Sync remote directory to local
filesync --help   # Display help message
```

## Setup
1. Clone the repository

```
git clone https://github.com/royborgen/filesync.git
cd filesync
```

2. Make the script executable
```
chmod +x filesync.sh
```

3. Rename `config.sample` to `config` and edit variables as needed

4. You can now sync your files by executing `./filesync.sh` from the scripts folder

## Optional
It is recommended to create an alias for simple execution. 
1. Create the file `~/.bash_aliases` (or edit if it already exist). Add the following line: 
```
alias sync="$HOME/path/to/filesync/filesync.sh"
```
2. Reload bash by typing the command `bash` 

You can now execute the script by typing the command `filesync` from anywhere. 

## License
This script is open source and licensend under the GPL-2.0 license. See the projects `LICENSE`file for details. 

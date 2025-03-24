#!/bin/bash

# Importing config vars to keep track of hosts for simple management
source ./config

# Function to check if remote system has files that do not exist locally
check_remote_files_not_in_local() {
    missing_on_local=$(rsync -arvh --dry-run --ignore-existing "$remotehost:$remotedir" "$localdir" 2>&1 | grep -E '^>f')

    if [ -n "$missing_on_local" ]; then
        echo "WARNING! The following files exist on the remote system but are NOT present locally:"
        echo "$missing_on_local"
        echo ""
        read -p "Do you want to delete these files on the remote system? (y/n): " choice
        case "$choice" in 
            y|Y ) echo "Proceeding with sync..."; return 0;;
            n|N ) echo "Sync canceled to prevent deletion."; exit 1;;
            * ) echo "Invalid choice. Sync canceled."; exit 1;;
        esac
    fi
}

# Function to check for deletions before syncing
confirm_deletion() {
    src="$1"
    dest="$2"

    deletions=$(rsync -arvh --progress --delete --dry-run "$src" "$dest" 2>&1 | grep -oP '(?<=deleting ).*')

    if [ -n "$deletions" ]; then
    	echo "WARNING! Sync will delete date in $dest:"
        echo "$deletions"
        echo ""
        read -p "Do you want to proceed with deletion? (y/n): " choice
        case "$choice" in 
            y|Y ) echo "Proceeding with sync..."; return 0;;
            n|N ) echo "Sync canceled."; exit 1;;
            * ) echo "Invalid choice. Sync canceled."; exit 1;;
        esac
    fi
}

# Display help if -h or --help is passed as an argument
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Usage: sync [OPTION]"
    	echo "Syncs a folder between two hosts using rsync"
    	echo ""
    	echo "Optional arguments:"
    	echo "push           Pushes data to the remote system"
    	echo "pull           Pulls data from the remote system"
    	echo "-h, --help     Displays this message"
    	echo ""
    	exit 0
fi

# Push data to the remote system
if [ "$1" = "push" ]; then
    	# Ensure we don't blindly delete remote files
	check_remote_files_not_in_local      
    	
	# Check what will be deleted on remote
	confirm_deletion "$localdir" "$remotehost:$remotedir"      
	
	rsync -arvh --progress --delete "$localdir" "$remotehost:$remotedir"
    exit 0
fi

# Pull data from the remote system
if [ "$1" = "pull" ]; then
    # Check what will be deleted locally
    confirm_deletion "$remotehost:$remotedir" "$localdir"
 
    rsync -arvh --progress --delete "$remotehost:$remotedir" "$localdir"
    exit 0
fi

# If no valid argument is provided, display a message
echo "Error: Invalid option. Use -h or --help for usage information."
exit 1


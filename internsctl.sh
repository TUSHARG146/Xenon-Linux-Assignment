#!/bin/bash

# Function to display manual page
display_manual() {
  cat <<EOF
INTENSCTL(1)                           User Commands                          INTENSCTL(1)

NAME
       internsctl - Custom Linux command for operations

SYNOPSIS
       internsctl <command> [options] [arguments]

DESCRIPTION
       internsctl is a custom Linux command for performing various operations.

OPTIONS
       --help    Display help information.
       --version Display command version.

COMMANDS
       cpu       Get CPU information.
       memory    Get memory information.
       user      User-related operations.
       file      File-related operations.

EXAMPLES
       internsctl cpu getinfo
       internsctl memory getinfo
       internsctl user create <username>
       internsctl user list
       internsctl user list --sudo-only
       internsctl file getinfo <file-name>
       internsctl file getinfo [options] <file-name>

SEE ALSO
       More information and examples can be found in the full documentation.

VERSION
       v0.1.0
EOF
}

# Function to display command help
display_help() {
  cat <<EOF
Usage: internsctl <command> [options] [arguments]

Commands:
  cpu getinfo         Get CPU information.
  memory getinfo      Get memory information.
  user create         Create a new user.
  user list           List all regular users.
  user list --sudo-only List all users with sudo permissions.
  file getinfo        Get information about a file.

Options:
  --help              Display help information.
  --version           Display command version.
EOF
}

# Function to display command version
display_version() {
  echo "internsctl v0.1.0"
}

# Function to get CPU information
get_cpu_info() {
  lscpu
}

# Function to get memory information
get_memory_info() {
  free
}

# Function to create a new user
create_user() {
  if [ -z "$1" ]; then
    echo "Error: Please provide a username."
  else
    sudo useradd -m "$1"
    echo "User '$1' created successfully."
  fi
}

# Function to list users
list_users() {
  if [ "$1" == "--sudo-only" ]; then
    getent passwd | cut -d: -f1,4 | awk -F: '$2 >= 1000 {print $1}'
  else
    getent passwd | cut -d: -f1
  fi
}

# Function to get file information
get_file_info() {
  local file_name="$1"
  local size_option="$2"
  local permissions_option="$3"
  local owner_option="$4"
  local last_modified_option="$5"

  if [ ! -e "$file_name" ]; then
    echo "Error: File '$file_name' not found."
  else
    local file_info="File: $file_name"
    
    if [ "$size_option" == "--size" ]; then
      file_info+="\nSize(B): $(stat --format=%s "$file_name")"
    fi
    
    if [ "$permissions_option" == "--permissions" ]; then
      file_info+="\nAccess: $(stat --format=%A "$file_name")"
    fi
    
    if [ "$owner_option" == "--owner" ]; then
      file_info+="\nOwner: $(stat --format=%U "$file_name")"
    fi
    
    if [ "$last_modified_option" == "--last-modified" ]; then
      file_info+="\nModify: $(stat --format=%y "$file_name")"
    fi

    echo -e "$file_info"
  fi
}

# Main script
case $1 in
  "cpu")
    case $2 in
      "getinfo")
        get_cpu_info
        ;;
      *)
        display_help
        ;;
    esac
    ;;
  "memory")
    case $2 in
      "getinfo")
        get_memory_info
        ;;
      *)
        display_help
        ;;
    esac
    ;;
  "user")
    case $2 in
      "create")
        create_user "$3"
        ;;
      "list")
        list_users "$3"
        ;;
      *)
        display_help
        ;;
    esac
    ;;
  "file")
    case $2 in
      "getinfo")
        shift
        get_file_info "$@"
        ;;
      *)
        display_help
        ;;
    esac
    ;;
  "--help")
    display_manual
    ;;
  "--version")
    display_version
    ;;
  *)
    display_help
    ;;
esac

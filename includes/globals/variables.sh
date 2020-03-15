#!/bin/bash

MINIMUM_MAC_OS="10.11.0"
OS_NAME="Mac OS "

# Retrieve from the system configuration utility the computer name, found in System
# Preferences | Sharing | Computer Name.
COMP_NAME="$(scutil --get ComputerName)"

# Retrieve from the system configuration utility the local network host name, found
# in System Preferences | Sharing | Computer Name.
LOCAL_HOST_NAME="$(scutil --get LocalHostName)"

## Retrieve the numerical portion of the macOS (or Mac OS) software version.
OS_VERSION="$(sw_vers -productVersion)"

# Semver OS number parsing
MAJOR_OS_NUMBER="$(echo "$OS_VERSION" | cut -d "." -f 1)"
MINOR_OS_NUMBER="$(echo "$OS_VERSION" | cut -d "." -f 2)"
PATCH_OS_NUMBER="$(echo "$OS_VERSION" | cut -d "." -f 3)"

# Retrieve the hostname info, including domain.
HOST_NAME="$(hostname)"

# Retrieve the name/ID of the user.
USER_NAME="$(id -un)"

# Retrieve the list of groups to which the current user belongs.
GROUPS_TO_WHICH_USER_BELONGS="$(id -Gn "$USER_NAME")"

# Retrieve the first and last names of the user by fingering him, then printing
# the 4th and 5th tokens on the line containing “Name”.
FULL_NAME="$(finger "$USER_NAME" | awk '/Name:/ {print $4" "$5}')"

# Retrieve the shell associated with the user in a similar fashion to how their full
# name was retrieved above.
USER_SHELL="$(finger "$USER_NAME" | awk '/Shell:/ {print $4}')"

export MINIMUM_MAC_OS
export OS_NAME
export COMP_NAME
export LOCAL_HOST_NAME
export OS_VERSION
export MINOR_OS_NUMBER
export HOST_NAME
export USER_NAME
export GROUPS_TO_WHICH_USER_BELONGS
export FULL_NAME
export USER_SHELL

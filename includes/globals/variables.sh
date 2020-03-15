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

# Print the hostname info, including domain.
HOST_NAME="$(hostname)"
export MINIMUM_MAC_OS
export OS_NAME
export COMP_NAME
export LOCAL_HOST_NAME
export OS_VERSION
export MINOR_OS_NUMBER
export HOST_NAME

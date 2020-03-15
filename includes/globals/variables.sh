#!/bin/bash

MINIMUM_MAC_OS="10.11.0"
OS_NAME="Mac OS "

# Retrieve from the system configuration utility the computer name, found in System
# Preferences | Sharing | Computer Name.
COMP_NAME="$(scutil --get ComputerName)"

# Retrieve from the system configuration utility the local network host name, found
# in System Preferences | Sharing | Computer Name.
LOCAL_HOST_NAME="$(scutil --get LocalHostName)"
export MINIMUM_MAC_OS
export OS_NAME
export COMP_NAME
export LOCAL_HOST_NAME

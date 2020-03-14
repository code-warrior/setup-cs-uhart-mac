#!/bin/bash

MINIMUM_MAC_OS="10.11.0"
OS_NAME="Mac OS "

# Retrieve from the system configuration utility the computer name, found in System
# Preferences | Sharing | Computer Name.
COMP_NAME="$(scutil --get ComputerName)"

#!/bin/bash

MINIMUM_MAC_OS="10.11.1"
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
MAJOR_NUMBER_OF_CURRENT_OS="$(echo "$OS_VERSION" | cut -d "." -f 1)"
MINOR_NUMBER_OF_CURRENT_OS="$(echo "$OS_VERSION" | cut -d "." -f 2)"
PATCH_NUMBER_OF_CURRENT_OS="$(echo "$OS_VERSION" | cut -d "." -f 3)"

# Semver OS number parsing for minimum os, Catalina
MINIMUM_MAJOR_NUMBER_REQUIRED="10"
MINIMUM_MINOR_NUMBER_REQUIRED="15"
MINIMUM_PATCH_NUMBER_REQUIRED="0"

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

VSCODE_EXTENSIONS=("editorconfig.editorconfig" "mkaufman.htmlhint" "umoxfo.vscode-w3cvalidation" "stylelint.vscode-stylelint" "syler.sass-indented" "dbaeumer.vscode-eslint")
ATOM_PACKAGES=("busy-signal" "intentions" "linter-ui-default" "linter" "editorconfig" "w3c-validation" "linter-stylelint" "emmet")

export VSCODE_EXTENSIONS
export ATOM_PACKAGES
export GIT_PROMPT=".git-prompt.sh"
export GIT_COMPLETION=".git-completion.sh"
export BASH_ALIAS=".bash_aliases"
export BASH_PFILE=".bash_profile"
export BASH_RUN_COMMANDS=".bashrc"
export EDITOR_CONFIG_SETTINGS=".editorconfig"
export ESLINT_SETTINGS=".eslintrc.json"
export STYLELINT_SETTINGS=".stylelintrc.json"
export MINIMUM_MAJOR_NUMBER_REQUIRED
export MINIMUM_MINOR_NUMBER_REQUIRED
export MINIMUM_PATCH_NUMBER_REQUIRED
export MAJOR_NUMBER_OF_CURRENT_OS
export MINOR_NUMBER_OF_CURRENT_OS
export PATCH_NUMBER_OF_CURRENT_OS
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

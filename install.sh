#!/bin/bash

# Although “xterm-256color” is the default for the type of TERMinal macOS is using,
# explicitly setting it here ensures a correct value.
export TERM=xterm-256color

# If the variables.sh file exists, source it.
if [[ -e ./includes/globals/variables.sh ]]; then
   source ./includes/globals/variables.sh
else
   printf "The file variables.sh does not exist. This script requires it. Exiting...\n"

   exit 1
fi

# If the functions.sh file exists, source it.
if [[ -e ./includes/globals/functions.sh ]]; then
   source ./includes/globals/functions.sh
else
   printf "The file functions.sh does not exist. This script requires it. Exiting...\n"

   exit 1
fi

if [[ "$MINOR_OS_NUMBER" -lt 11 ]]; then
   print_msg "error" "This script does not support the version of Mac OS that you’re running. Please update "
   print_msg "error" "your OS and try again."

   exit 1
else
   if [[ "$MINOR_OS_NUMBER" -eq 11 ]]; then
      print_msg "warn" "Your OS is outdated. Consider upgrading before continuing."
   else
      if [[ "$MINOR_OS_NUMBER" -gt 10 ]] && [[ "$MINOR_OS_NUMBER" -lt 15 ]]; then
         OS_NAME="macOS"
      fi
   fi
fi

sudo -p "Enter your password, which, for security purposes, won’t be repeated in The Terminal as you type it: " echo "${BG_GREEN}${BLACK} > Thank you! ${RESET}"

print_msg "log" " "
print_msg "log" "Your current setup is: "
print_msg "log" " "
print_msg "log" "Operating System: $OS_NAME $OS_VERSION"
print_msg "log" "Shell:            $USER_SHELL"
print_msg "log" "Computer name:    $COMP_NAME"
print_msg "log" "Local hostname:   $LOCAL_HOST_NAME"
print_msg "log" "Full hostname:    $HOST_NAME"
print_msg "log" "Long user name:   $FULL_NAME"
print_msg "log" "Short user name:  $USER_NAME"

#####################################################################################
# Do a quiet (-q) grep word search (-w) for “admin” privileges in the list of groups
# to which the current user belongs. If they are an admin, proceed quietly.
#####################################################################################
if echo "$GROUPS_TO_WHICH_USER_BELONGS" | grep -q -w admin; then
   echo "" > /dev/null
else
   print_msg "error" " "
   print_msg "error" "The current user does not have administrator privileges. This program must be run "
   print_msg "error" "by a user with admin privileges. Exiting..."

   exit 1
fi

#####################################################################################
# Install (i) all (a) available software updates.
#####################################################################################
print_msg "log" "Running software update... "
print_msg "log" " "
sudo softwareupdate -ia
print_msg "log" " "
print_msg "log" "Software update has been run."
print_msg "log" "Setting OS configurations..."

print_msg "log" "Enabling the following features when clicking the clock in the upper "
print_msg "log" "right hand corner of the login window: Host name, OS version number, and IP address."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

print_msg "log" "Show all filename extensions in Finder."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

print_msg "log" "Show Path Bar (at the bottom of windows) in Finder."
defaults write com.apple.finder ShowPathbar -bool true

print_msg "log" "Show Status Bar (below Path Bar) in Finder."
defaults write com.apple.finder ShowStatusBar -bool true

print_msg "log" "Hide/show the Dock when the mouse hovers over the screen edge of the Dock."
defaults write com.apple.dock autohide -bool true

print_msg "log" "Use UTF-8 as input to The Terminal."
defaults write com.apple.terminal StringEncodings -array 4

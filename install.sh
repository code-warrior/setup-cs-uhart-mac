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

print_msg "log" "This script will install, update, and configure files and applications "
print_msg "log" "related to software used by the Dept of Computing Sciences at The "
print_msg "log" "University of Hartford."

#####################################################################################
# Check if macOS version is at least Catalina (10.15.0)
#####################################################################################
if [[ "$MAJOR_NUMBER_OF_CURRENT_OS" -lt "$MINIMUM_MAJOR_NUMBER_REQUIRED" ]]; then
   print_msg "error" "You are running $OS_VERSION of macOS, which is from before 2019. The minimum"
   print_msg "error" "version required to run the software installed by this script is $MINIMUM_MAJOR_NUMBER_REQUIRED.$MINIMUM_MINOR_NUMBER_REQUIRED.$MINIMUM_PATCH_NUMBER_REQUIRED."
   print_msg "error" "(Catalina). Please update your OS and try again. Exiting..."

   exit 1
else
   print_msg "warn" "This installation script was updated in February 2022 to work in macOS"
   print_msg "warn" "Monterey (12.1). It may work in versions as early as macOS Catalina "
   print_msg "warn" "($MINIMUM_MAJOR_NUMBER_REQUIRED.$MINIMUM_MINOR_NUMBER_REQUIRED.$MINIMUM_PATCH_NUMBER_REQUIRED.). However, versions older than that are likely not compatible"
   print_msg "warn" "with this script and are inadvisable to use."
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
# Run software update, and, install (i) all (a) available packages.
#####################################################################################
print_msg "log" "Running software update... "
print_msg "log" " "
sudo softwareupdate -ia
print_msg "log" " "
print_msg "log" "Software update has been run."

#####################################################################################
# Check for command line tools.
#####################################################################################
print_msg "log" "Checking for XCode Command Line Tools..."

#####################################################################################
# If the command line tools have been installed, they would appear as
# `com.apple.pkg.CLTools_Executables` in the result of `pkgutil --pkgs`. Similarly,
# `pkgutil --pkgs=com.apple.pkg.CLTools_Executables` yields
# `com.apple.pkg.CLTools_Executables`. Thus, if running the `pkgutil` command doesn’t
# return a null string, then the tools have been installed.
#####################################################################################
if [[ -n "$(pkgutil --pkgs=com.apple.pkg.${cmdline_version})" ]]; then
   print_msg "log" "Command Line Tools are installed!"
else
   print_msg "error" "Command Line Tools are not installed!"
   print_msg "error" "Running 'xcode-select --install' Please click Install!"

   xcode-select --install
fi

print_msg "log" "Setting OS configurations..."

print_msg "log" "Enabling the following features when clicking the clock in the upper "
print_msg "log" "right hand corner of the login window: Host name, OS version number, and IP address."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

print_msg "log" " "
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

print_msg "log" "Display full POSIX path as Finder window title."
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

print_msg "log" "Bring up a dialog box when the power button is held for 2 seconds."
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

print_msg "log" "Request user’s password to wake from sleep or return from screen saver."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

print_msg "log" "Expose the entire \"save\" panel (instead of collapsing it) when saving."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

print_msg "log" "Expose the entire \"print\" panel (instead of collapsing it) when printing."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

print_msg "log" "Restart affected applications."
for app in Finder Dock SystemUIServer;
   do killall "$app" >/dev/null 2>&1;
done

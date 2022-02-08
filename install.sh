#!/bin/bash

# TODO
# * Install VS Code, then Spotless
# * Install Node

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

cmdline_version="CLTools_Executables"

#####################################################################################
# If the command line tools have been installed, they would appear as
# `com.apple.pkg.CLTools_Executables` in the result of `pkgutil --pkgs`. Similarly,
# `pkgutil --pkgs=com.apple.pkg.CLTools_Executables` yields
# `com.apple.pkg.CLTools_Executables`. Thus, if running the `pkgutil` command doesn’t
# return a null string, then the tools have been installed.
#####################################################################################
if [[ -n $(pkgutil --pkgs=com.apple.pkg."${cmdline_version}") ]]; then
   print_msg "log"  "Running software update on Mac OS... " true

   # Install (-i) recommended (-r) software updates
   sudo softwareupdate -i -r
   print_msg "log" "Command Line Tools are installed!"
else
   print_msg "error" "Command Line Tools are not installed!"
   print_msg "error" "Running 'xcode-select --install' Please click Install!"

   xcode-select --install
fi

print_msg "log" "Setting OS configurations..."

#####################################################################################
# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login
# window
#####################################################################################
print_msg "log" "Setting OS option that, when clicking the clock in the login window, "
print_msg "log" "reveals IP address, hostname, and OS version."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

#####################################################################################
# Only use UTF-8 in The Terminal
#####################################################################################
print_msg "log" "Setting OS option that accepts UTF-8 as input in The Terminal."
sudo defaults write com.apple.terminal StringEncodings -array 4

#####################################################################################
# Install environment, including Git, Bash, and Editorconfig
#####################################################################################
base_URL="https://raw.githubusercontent.com/code-warrior/web-dev-env-config-files/master"

install_configuration_file "$GIT_PROMPT" "$base_URL"/terminal/git-env-for-mac-and-windows/
install_configuration_file "$GIT_COMPLETION" "$base_URL"/terminal/git-env-for-mac-and-windows/
install_configuration_file "$BASH_ALIAS" "$base_URL"/terminal/mac/
install_configuration_file "$BASH_RUN_COMMANDS" "$base_URL"/terminal/mac/
install_configuration_file "$BASH_PFILE" "$base_URL"/terminal/mac/
install_configuration_file "$EDITOR_CONFIG_SETTINGS" "$base_URL"/

#####################################################################################
# Install typefaces
#####################################################################################
print_msg "log" "Installing typefaces..."

install_typeface "IBMPlexMono-Regular.ttf" \
   "IBM Plex Mono" \
   "https://fonts.google.com/download?family=IBM%20Plex%20Mono" \
   "IBM_Plex_Mono.zip" \
   "IBM_Plex_Mono"
install_typeface "UbuntuMono-Regular.ttf" \
   "Ubuntu Mono" \
   "https://fonts.google.com/download?family=Ubuntu%20Mono" \
   "Ubuntu_Mono.zip" \
   "Ubuntu_Mono"
install_typeface "Inconsolata-VariableFont_wdth,wght.ttf" \
   "Inconsolata" \
   "https://fonts.google.com/download?family=Inconsolata" \
   "Inconsolata.zip" \
   "Inconsolata"
install_typeface \
   "CourierPrime-Regular.ttf" \
   "Courier Prime" \
   "https://fonts.google.com/download?family=Courier%20Prime" \
   "Courier_Prime.zip" \
   "Courier_Prime"

#####################################################################################
# Install Logitech Options for MX Master 3 mouse and MX Keys keyboard
#####################################################################################
install 'Logitech Options' 'options_installer.zip' 'https://download01.logi.com/web/ftp/pub/techsupport/options/options_installer.zip' \
  -H 'authority: download01.logi.com' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'referer: https://www.logitech.com/' \
  -H 'accept-language: en-US,en;q=0.9'

#####################################################################################
# Install browsers
#####################################################################################
print_msg "log" "Installing browsers..."

install 'Firefox' 'Firefox 96.0.3.dmg' 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/96.0.3/mac/en-US/Firefox%2096.0.3.dmg' \
  -H 'authority: download-installer.cdn.mozilla.net' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://www.mozilla.org/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Firefox Developer Edition' 'Firefox 97.0b9.dmg' 'https://download-installer.cdn.mozilla.net/pub/devedition/releases/97.0b9/mac/en-US/Firefox%2097.0b9.dmg' \
  -H 'authority: download-installer.cdn.mozilla.net' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://www.mozilla.org/' \
  -H 'accept-language: en-US,en;q=0.9'

# This is the Intel chip download. Go back to Microsoft’s site for a link to the M1 chip download.
install 'Microsoft Edge (97)' 'MicrosoftEdge-97.0.1072.76.pkg' 'https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/MicrosoftEdge-97.0.1072.76.pkg?platform=Mac&Consent=1&channel=Stable' \
  -H 'Connection: keep-alive' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Referer: https://www.microsoft.com/' \
  -H 'Accept-Language: en-US,en;q=0.9'

# This is the Intel chip download. Go back to Brave’s site for a link to the M1 chip download.
install 'Brave Browser' 'Brave-Browser.dmg' 'https://referrals.brave.com/latest/Brave-Browser.dmg' \
  -H 'authority: referrals.brave.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://brave.com/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Vivaldi Browser (5.0.2497.48)' 'Vivaldi.5.0.2497.48.universal.dmg' 'https://downloads.vivaldi.com/stable/Vivaldi.5.0.2497.48.universal.dmg' \
  -H 'authority: downloads.vivaldi.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-gpc: 1' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'referer: https://vivaldi.com/' \
  -H 'accept-language: en-US,en;q=0.9'

#####################################################################################
# Install Java
#####################################################################################
print_msg "log" "Installing Java..."

install 'Java 8 Update 321' 'jre-8u321-macosx-x64.dmg' 'https://sdlc-esd.oracle.com/ESD6/JSCDL/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jre-8u321-macosx-x64.dmg?GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jre-8u321-macosx-x64.dmg&BHost=javadl.sun.com&File=jre-8u321-macosx-x64.dmg&AuthParam=1643562635_38ceb232f182e25675b5877fd03599fe&ext=.dmg' \
  -H 'Connection: keep-alive' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Referer: https://java.com/' \
  -H 'Accept-Language: en-US,en;q=0.9'

install 'Java SE Development Kit' 'jdk-17_macos-x64_bin.dmg' 'https://download.oracle.com/java/17/latest/jdk-17_macos-x64_bin.dmg' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Referer: https://www.oracle.com/java/technologies/downloads/' \
  -H 'Accept-Language: en-US,en;q=0.9'

#####################################################################################
# Installing IDEs/editors
#####################################################################################
print_msg "log" "Installing IDEs and editors..."

install 'Visual Studio Code' 'VSCode-darwin-universal.zip' 'https://az764295.vo.msecnd.net/stable/899d46d82c4c95423fb7e10e68eba52050e30ba3/VSCode-darwin-universal.zip' \
  -H 'authority: az764295.vo.msecnd.net' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://code.visualstudio.com/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Node' 'node-v16.13.2.pkg' 'https://nodejs.org/dist/v16.13.2/node-v16.13.2.pkg' \
  -H 'authority: nodejs.org' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'referer: https://nodejs.org/en/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Eclipse Installer' 'eclipse-inst-jre-mac64.dmg' 'https://ftp.osuosl.org/pub/eclipse/oomph/epp/2021-12/R/eclipse-inst-jre-mac64.dmg' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: cross-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Referer: https://www.eclipse.org/' \
  -H 'Accept-Language: en-US,en;q=0.9'

install 'Sublime Text (3.2.2)' 'Sublime Text Build 3211.dmg' 'https://download.sublimetext.com/Sublime%20Text%20Build%203211.dmg' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Referer: https://www.sublimetext.com/' \
  -H 'Accept-Language: en-US,en;q=0.9'

install 'Atom' 'atom-mac.zip' 'https://atom-installer.github.com/v1.58.0/atom-mac.zip?s=1627025609&ext=.zip' \
  -H 'authority: atom-installer.github.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://atom.io/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Arduino IDE' 'arduino-1.8.19-macosx.zip' 'https://downloads.arduino.cc/arduino-1.8.19-macosx.zip' \
  -H 'authority: downloads.arduino.cc' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'referer: https://www.arduino.cc/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Zoom' 'Zoom.pkg' 'https://cdn.zoom.us/prod/5.9.3.4239/Zoom.pkg'

#####################################################################################
# Install Homebrew
#####################################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Lynx is the text-only browser
brew install lynx

# Splint is the C linter
brew install splint

# Shellcheck is the bash linter
brew install shellcheck

# Checkstyle is the Java linter
brew install checkstyle

# Sass is the CSS preprocessor
brew install sass/sass/sass

#####################################################################################
# Set OS configurations
#####################################################################################
print_msg "log" "Setting OS configurations..."

print_msg "log" "Enabling the following features when clicking the clock in the upper"
print_msg "log" "right hand corner of the login window: Host name, OS version number, and"
print_msg "log" "IP address."
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

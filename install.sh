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
   print_msg "log"  "Running software update on Mac OS... "

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

install_configuration_file "$ESLINT_SETTINGS" https://gist.githubusercontent.com/code-warrior/c6f1b02730b6a7d08c241f5bf1b62258/raw/2cdf414c31785847889697c67a7bd4bbad35393c/
install_configuration_file "$STYLELINT_SETTINGS" https://gist.githubusercontent.com/code-warrior/a766f7c32bab9a82b467601800b00a46/raw/768717143df9db9c593dabb38c3c7aa63c87f66b/
install_configuration_file "$SASS_LINT_SETTINGS" "$base_URL"/sass/.sass-lint.yml
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

install 'Java 8 Update 321' 'jre-8u321-macosx-x64.dmg' 'https://sdlc-esd.oracle.com/ESD6/JSCDL/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jre-8u321-macosx-x64.dmg?GroupName=JSC&FilePath=/ESD6/JSCDL/jdk/8u321-b07/df5ad55fdd604472a86a45a217032c7d/jre-8u321-macosx-x64.dmg&BHost=javadl.sun.com&File=jre-8u321-macosx-x64.dmg&AuthParam=1644789344_f13bac63ab0024f7295015e17697ee39&ext=.dmg' \
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
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: s_fid=01712E4A9B6B54E4-112EA5CED7B4517C; s_cc=true; bm_mi=5349EFD61667DED1A49DCC382B01AF49~eKR0jT6sicAyQpe7R2GedF5MnLszY0bJq2agvZ+eeRlwcDrAx/2cjMbH5b8v2kxv4498aumx6563leLz1fZ/WNpZr+P5kD2xOwONnUu67fgeWenIQ2x8smVN6gh88KE+grU4is5/gKIkxsx96wn9x8CBIv6QAzK9fqVePoyxFCqhPGEvH353rIB41V02svGOypv6Z6qxuL3B9EeTIWgrSnzDLzPnUZQeKnCuqX+7Yh3FpuHh6nqo9lPrU03skFlk; ELOQUA=GUID=AD28968D69264E07BFF3C32BE0F99213; ORA_FPC=id=f023f8e1-eb13-49c4-98b6-0ce6469ed8d6; WTPERSIST=; ak_bmsc=4E6BC4532B4CC396D12E2F1F93862924~000000000000000000000000000000~YAAQVfs7F5a5Zul+AQAAvfAA9Q5BJbbF2WDi3nsbTUvSSX6byjQX1S5tC8dgZO80k4rUzkbF71vNf5NhGYhH1L8u7vmiqKGo17oaU+gRvTsUPa9E9VZJU07/oiDkaGeSabjDUGL1vt9dpsV7qMvHOgRxeWQUvrxkz2B1RWN1g5u09KLQ6VFkpLEQDvj5CXGatxr3ZHq6NY+qCO+lCJlBn0U3buJduImaQuR65BqRlDBE/zi4YfohCyosLhZxLHiKpi7DCLhw39TlN+S4oe4NLdYbbsRNSKeiav79mL49HdIgktk0vaox2wmZTAgG6l/XKEvLTR+/NWaLkF773UFI9po/7NyZyVBnZbleQ6Ik/e+9bhVKwPsPNBHCn/oY72Egf9LmdDQeHh4UhkGEUEvuDae4UjQkDbRRNMKEWlvTbJ2VBPEMPuYvQ+enocsT8da6G6Hm5i72Uvlk4byh4wRobXmbILtYmLyWy1YaeAsnp3jE1Oa5YTC4V8nU8ze+8l5HV1hwdm6/5q9MfqGloFOBzg==; _gcl_au=1.1.82532865.1644787986; oraclelicense=141; OAMAuthnHintCookie=0@1644788034; AKA_A2=A; utag_main=v_id:017ef500ec2f00181b92ae2c859205078005807000bd0$_sn:1$_se:6$_ss:0$_st:1644789867907$ses_id:1644787985457%3Bexp-session$_pn:3%3Bexp-session; gpw_e24=https%3A%2F%2Fwww.oracle.com%2Fjava%2Ftechnologies%2Fjavase%2Fjavase8u211-later-archive-downloads.html; s_sq=%5B%5BB%5D%5D; s_nr=1644788076667-New; RT="z=1&dm=oracle.com&si=782e261c-c4cd-43b4-9691-69a249f76563&ss=kzlsargf&sl=3&tt=2tb&bcn=%2F%2F173bf108.akstat.io%2F&ld=1s5o&nu=qaz1psod&cl=1yuz&ul=1yx0&hd=1z3u"; bm_sv=4F868159B114822CD41C5C2FE3AB1707~LApspQY0/EtJhTq+usv+T3OqGuOcFt8kbkpjlW6vm/7fw0m9EX9CEBiT8/FnusQ6P0mmINaiid2aZdQjM+zreHoDJE3MhlQF3+qITCQ/u3l2tbyz7yBfrHyJ9zf7Ep4LS+FpCLwR9KsIt8WcgxcvoHqf35meBUwKWYY9ahoREN0='

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

print_msg "warn" "Add VS Code to your path for command line usage before continuing:"
print_msg "log" "Launch VS Code"
print_msg "log" "Open the command palette (CMD + SHIFT + P), then type 'shell command'"
print_msg "log" "Choose 'Shell Command: Install 'code' command in PATH'"
print_msg "log" "Close VS Code"
pause

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

print_msg "log" "Installing Node..."

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

sudo npm install --global gulp-cli
sudo npm install eslint

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

install 'GitHub' 'GitHubDesktop-x64.zip' 'https://desktop.githubusercontent.com/github-desktop/releases/2.9.6-9196a1ae/GitHubDesktop-x64.zip' \
  -H 'authority: desktop.githubusercontent.com' \
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
  -H 'referer: https://desktop.github.com/' \
  -H 'accept-language: en-US,en;q=0.9'

install 'Zoom' 'Zoom.pkg' 'https://cdn.zoom.us/prod/5.9.3.4239/Zoom.pkg'

# Install Dockspacer, which creates spacers in The Dock so icons can be neatly grouped
if [[ -e "/usr/local/bin/dockspacer" ]]; then
   print_msg "warn" "Dockspacer already installed. Skipping..."
else
   curl -OL https://github.com/code-warrior/dockspacer/raw/master/dockspacer
   chmod 755 dockspacer
   sudo mv dockspacer /usr/local/bin/

   if [[ -e "/usr/local/bin/dockspacer" ]]; then
      print_msg "log" "Dockspacer installed."
   else
      print_msg "error" "Dockspacer could not be installed, either because it"
      print_msg "error" "could not be downloaded, you don’t have sufficient"
      print_msg "error" "privilege, or some other issue. Visit"
      print_msg "error" "https://github.com/code-warrior/dockspacer to install"
      print_msg "error" "manually."
   fi
fi

#####################################################################################
# Install Spectacle
#####################################################################################
if [[ -d "/Applications/Spectacle.app/" ]]; then
   print_msg "warn" "Spectacle is already installed on this machine."
   pause
else
   install 'Spectacle' 'Spectacle+1.2.zip' 'https://s3.amazonaws.com/spectacle/downloads/Spectacle+1.2.zip'

   print_msg "log" "Launching Spectacle..."
   open /Applications/Spectacle.app

   print_msg "warn" "If you’re running Spectacle for the first time, do the following:"
   print_msg "warn" "1. Click Open System Preferences."
   print_msg "warn" "2. Unlock the lock in the lower left corner of Security & Privacy, "
   print_msg "warn" "   if it’s locked."
   print_msg "warn" "3. Check the box to the left of the Spectacle icon."
   print_msg "warn" "4. Lock the dialog box."
   print_msg "warn" "5. Click the glasses icon in the top right corner of the Desktop, known as "
   print_msg "warn" "   Menu Extras, or menulets."
   print_msg "warn" "6. Click Preferences..."
   print_msg "warn" "7. Check the box next to Launch Spectacle at login."
   pause

   print_msg "log" "Downloading custom Spectacle shortcuts (Shortcuts.json)..."
   curl -O https://raw.githubusercontent.com/code-warrior/web-dev-env-config-files/master/spectacle/Shortcuts.json

   print_msg "log" "Installing custom Spectacle shortcuts (Shortcuts.json)..."
   mv -v Shortcuts.json ~/Library/Application\ Support/Spectacle/

   if [[ -e Shortcuts.json ]]; then
      print_msg "error" "The Spectacle shortcuts were not successfully"
      print_msg "error" "installed. Please investigate, then continue."
      pause
   else
      print_msg "log" "The Spectacle shortcuts were installed successfully."
   fi
fi

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

# If VSCode is configured at the command line, then install the extensions
if code --help > /dev/null 2>&1; then
   for i in "${!VSCODE_EXTENSIONS[@]}"; do
      install_plugin_for "vscode" "${VSCODE_EXTENSIONS[$i]}"
   done
else
   print_msg "error" "VSCode isn’t configured to work from the command line. This may be the"
   print_msg "error" "result of not having configured it, not having installed VS Code, or"
   print_msg "error" "some other issue. If VS Code is installed, then visit "
   print_msg "error" "https://code.visualstudio.com/docs/setup/mac to learn how to configure"
   print_msg "error" "VS Code to work from the command line. Then, look at the"
   print_msg "error" "VSCODE_EXTENSIONS array in includes/globals/variables.sh for a list of"
   print_msg "error" "the extensions that should installed manually."
   pause
fi

# If Atom’s package manager (APM) was installed, then install the packages
if [[ -n "$(apm install)" ]]; then
   for i in "${!ATOM_PACKAGES[@]}"; do
      install_plugin_for "atom" "${ATOM_PACKAGES[$i]}"
   done
else
   print_msg "error" "Atom’s package manager (APM) is not installed."
   print_msg "error" "1. Launch Atom."
   print_msg "error" "2. Click Atom in the menu bar on the left, next to the Apple icon."
   print_msg "error" "3. Choose Install Shell Commands."
   print_msg "error" "4. Launch The Terminal."
   print_msg "error" "5. See the array ATOM_PACKAGES in includes/globals/variables.sh for a"
   print_msg "error" "   list of packages to install manually, using the command 'apm install'."
   pause
fi

#####################################################################################
# Set OS configurations
#####################################################################################
print_msg "log" "Setting OS configurations..."

print_msg "log" "Enabling the following features when clicking the clock in the upper"
print_msg "log" "right hand corner of the login window: Host name, OS version number, and"
print_msg "log" "IP address."
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

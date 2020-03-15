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

sudo -p "Enter your password, which, for security purposes, won’t be repeated in "\
"The Terminal as you type it: " echo "${BG_GREEN}${BLACK} > Thank you! ${RESET}"

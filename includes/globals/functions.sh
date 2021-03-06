#!/bin/bash

#
# If colors.sh (-e)xists, then source it.
#
if [[ -e ./includes/globals/colors.sh ]]; then
   source ./includes/globals/colors.sh
else
   printf "The file colors.sh does not exist. This script requires it. Exiting...\n"

   exit 1
fi

#
# Required by the “print_msg” function below.
#
function print_error_msg () {
    printf "%s \n" "${BG_RED}${WHITE}${BOLD} ERROR: In addition to ${RESET}${BG_WHITE}${BLACK} $1 ${RESET}${BG_RED}${WHITE}${BOLD}, the string you would like  ${RESET}${BG_WHITE}${BLACK} ${FUNCNAME[0]} ${RESET}${BG_RED}${WHITE}${BOLD} to render is required as the second argument. "\
            " For example, ${RESET}${BG_WHITE}${BLACK} print_msg \"$1\" \"Content here.\"" "${RESET}"
}

#
# Example usage:
#    print_msg "log" "The procedure has been carried out successfully.
#    print_msg "warn" "Although not fatal, an error was generated by the previous command."
#    print_msg "error" "A required file was not found. Thus, exiting..."
#
function print_msg () {
   # Enable (-s) case-insensitive (nocasematch) pattern matching.
   # (https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)
   shopt -s nocasematch

   # Process the first argument...
   case "$1" in
      "log" )
         # then check the second argument, starting by verifying that it’s got a length greater than 0
         if [[ -n "$2" ]]; then
            printf "%s > %s %s\n" "${BG_GREEN}${BLACK}${BOLD}" "$2" "${RESET}"
         else
            print_error_msg "$1"
         fi
         ;;

      "warn" )
         # then check the second argument, starting by verifying that it’s got a length greater than 0
         if [[ -n "$2" ]]; then
            printf "%s \n" "${BG_YELLOW}${BLACK}${BOLD} > $2 ${RESET}"
         else
            print_error_msg "$1"
         fi
         ;;

      "error" )
         # then check the second argument, starting by verifying that it’s got a length greater than 0
         if [[ -n "$2" ]]; then
            printf "%s \n" "${BG_RED}${BLACK}${BOLD} > $2 ${RESET}"
         else
            print_error_msg "$1"
         fi
         ;;

      # Handle the case where the first argument is empty or not one of “log”, “warn”, or ”error”.
      "" | * )
         printf "%s \n" "${BG_RED}${WHITE}${BOLD} ERROR: The function ${RESET}${BG_WHITE}${BLACK} ${FUNCNAME[0]} ${RESET}${BG_RED}${WHITE}${BOLD} requires two arguments: log, warn, or error as its first, and the string you’d "\
         " like to render as its second. For example, ${RESET}${BG_WHITE}${BLACK} print_msg \"log\" \"Content here.\"" "${RESET}"
         ;;
   esac
}

#!/bin/bash

# Foreground colors
BLACK="$(tput setaf 0)"
WHITE="$(tput setaf 7)"

# Background colors
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_YELLOW="$(tput setab 3)"
BG_WHITE="$(tput setab 7)"

# Style-related
BOLD="$(tput bold)"

# Reset formatting
RESET="$(tput sgr0)"

# Exports
export BLACK
export WHITE
export BG_RED
export BG_GREEN
export BG_YELLOW
export BG_WHITE
export BOLD
export RESET

#!/usr/bin/env bash

function process_list() {
  # Parameter #1 is the command to generate the list
  # Parameter #2 is the filename of the old archived list

  # Parse out the command name and make sure it is available
  cmd_name=$(awk '{print $1}' <<< "$1")

  if ! hash "$cmd_name" &> /dev/null; then
    echo "${BASH_SOURCE[-1]} > ${FUNCNAME[0]}: command '$cmd_name' not found; aborting"
    return
  fi

  # If the command is 'brew' then make sure we're current before kicking off the lists
  if [ "$cmd_name" == "brew" ]; then
    brew update
  fi

  if ! cmd_output="$(eval "$1")"; then
    : # No-op; skipping errors
  fi

  sort --ignore-case <<< "$cmd_output" > "$2"
}

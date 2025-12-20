#!/bin/bash

set -eu
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

function run() {
  local script_name="${1}"; shift

  echo "** Calling script: ${script_name}"
  "${SCRIPT_DIR}"/"${script_name}"
}

# Enabled scripts
run "sage-attention.sh"

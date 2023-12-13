#!/usr/bin/env bash

HOME_LOC=

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--home*)
      if [[ $1 == --home=* ]]; then
        HOME_LOC=$(echo $1 | cut -d'=' -f2)
        shift 1
      else
        HOME_LOC=$2
        shift 2
      fi
      ;;
    *)
      echo "Default"
      ;;
  esac
done
echo "$HOME_LOC"
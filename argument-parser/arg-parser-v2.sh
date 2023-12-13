#!/usr/bin/env bash

function process_parameter() {
  export PARAM_CONFIG_COUNT=
  export shortArray=
  export longArray=
  export paramNameArray=

  load_args_database

  while [[ $# -gt 0 ]]; do
    for((i=1;i<="$PARAM_CONFIG_COUNT";i++)); do
      short=$(echo "$shortArray" | cut -d":" -f"$i")
      long=$(echo "$longArray" | cut -d":" -f"$i")
      param=$(echo "$paramNameArray" | cut -d":" -f"$i")

      if echo "$1" | grep "=" > /dev/null; then
        argName=$(echo "$1" | cut -d'=' -f1)
        argValue=$(echo "$1" | cut -d'=' -f2)
        if [[ "$argName" = "$short" || "$argName" = "$long" ]]; then
          eval "export PARAM_$param""_VALUE=$argValue"
        fi
        shift 1
      else
        argName=$1
        argValue=$2
        if [[ "$argName" = "$short" || "$argName" = "$long" ]]; then
          eval "export PARAM_$param""_VALUE=$argValue"
        fi
        shift 2
      fi
    done
  done

  unset PARAM_CONFIG_COUNT
#  env | grep "^PARAM_" | sort

}

function load_args_database() {
  CONFIG_FILE_PATH=./arg-parser.config

  if [ -n "$PARAM_CONFIG_FILE_VALUE" ]; then
    CONFIG_FILE_PATH=$PARAM_CONFIG_FILE_VALUE
  fi
#  echo "Loading configuration file : $CONFIG_FILE_PATH"

  # Trimming the multiple tabs and spaces into single space, Removing the empty lines
  PARAMS=$(tr -s ' ' < "$CONFIG_FILE_PATH" | grep -v "^#" | grep -v "^$")
  PARAM_CONFIG_COUNT=$(echo "$PARAMS" | wc -l)

  while IFS= read -r line; do
    short=$(echo "$line" | cut -d'|' -f1)
    long=$(echo "$line" | cut -d'|' -f2)

    [ -z "$shortArray" ] && shortArray=$short || shortArray="$shortArray:$short";
    [ -z "$longArray" ] && longArray=$long || longArray="$longArray:$long";

    paramName=$(echo "$line" | cut -d'|' -f3)
    if [ -z "$paramName" ]; then
      paramName=$long
      paramName=${paramName##--}
    fi
    paramName=${paramName//-/_}
    paramName=${paramName// /_}
    paramName=${paramName^^}

    [ -z "$paramNameArray" ] && paramNameArray=$paramName || paramNameArray="$paramNameArray:$paramName"

  done <<< "$PARAMS"
}
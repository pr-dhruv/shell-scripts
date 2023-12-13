#!/usr/bin/env bash

function load_parameter_config() {
  clear
  echo "$*"

  CONFIG_FILE_PATH=./arg-parser.config

  if [ -n "$PARAM_CONFIG_FILE_VALUE" ]; then
    CONFIG_FILE_PATH=$PARAM_CONFIG_FILE_VALUE
  fi
  echo "Loading configuration file : $CONFIG_FILE_PATH"

  # Trimming the multiple tabs and spaces into single space, Removing the empty lines
  PARAMS=$(cat "$CONFIG_FILE_PATH" | tr -s ' ' | grep -v "^#" | grep -v "^$")
  export PARAM_CONFIG_COUNT=$(echo "$PARAMS" | wc -l)

  while IFS= read -r line; do
  #  echo "Line: $line"

    # Fetching short option
    shortFlag=$(echo "$line" | cut -d'|' -f1)

    # Fetching full option name
    fullFlagName=$(echo "$line" | cut -d'|' -f2)

    # Parameter Name
    paramName=$(echo "$line" | cut -d'|' -f3)

#    paramName=${paramName##--}    # Trimming start --
    paramName=${paramName//-/_}   # Replacing - with _
    paramName=${paramName// /_}   # Replacing ' ' with _
    paramName=${paramName^^}      # To Upper case

    while [[ $# -gt 0 ]]; do
      echo "$* || $shortFlag $fullFlagName"
      echo "$1" | grep '=' > /dev/null
      if [ $? == 0 ]; then
        queryParam=$(echo $1 | cut -d'=' -f1)
        queryValue=$(echo $1 | cut -d'=' -f2)
        echo "queryParam: $queryParam, queryValue: $queryValue"
        if [[ "$queryParam" = "$shortFlag" || "$queryParam" = "$fullFlagName" ]]; then
          eval "export PARAM_$paramName""_SHORT=$shortFlag";
          eval "export PARAM_$paramName""_LONG=$fullFlagName"
          eval "export PARAM_$paramName""_VALUE=$queryValue"
        fi
        echo "-----"
        shift 1
        break
      else
        queryParam=$(echo $1 | cut -d'=' -f1)
        queryValue=$(echo $1 | cut -d'=' -f2)
        echo "queryParam: $queryParam, queryValue: $queryValue"
        if [[ "$queryParam" = "$shortFlag" || "$queryParam" = "$fullFlagName" ]]; then
          eval "export PARAM_$paramName""_SHORT=$shortFlag";
          eval "export PARAM_$paramName""_LONG=$fullFlagName"
          eval "export PARAM_$paramName""_VALUE=$queryValue"
        fi
        echo "-----"
        value=$2
        eval "export PARAM_$paramName""_VALUE=$value"
        shift 2
        break
      fi
    done

  done <<< "$PARAMS"

  echo "Total Param: "
  env | grep "PARAM_"
  echo "==============="
#  ARGS=$(env | grep 'PARAM_' | cut -d'=' -f1)
#  ARGS=$(env | grep 'PARAM_' | cut -d'=' -f1,2)
#  echo "$ARGS" | sort
#  SHORT_ARGS=$(echo "$ARGS" | grep "^PARAM_.*_SHORT.*$")
#  SHORT_ARGS=$(echo "$SHORT_ARGS" | sort)
#  echo "$SHORT_ARGS
#  -----"
#  LONG_ARGS=$(echo "$ARGS" | grep "^PARAM_.*_LONG.*$")
#  LONG_ARGS=$(echo "$LONG_ARGS" | sort)
#  echo "$LONG_ARGS
#  -----"
#  VALUE_ARGS=$(echo "$ARGS" | grep "^PARAM_.*_VALUE.*$")
#  VALUE_ARGS=$(echo "$VALUE_ARGS" | sort)
#  echo "$VALUE_ARGS
#  -----"
}

#function load_arguments() {
#  clear
#  load_parameter_config
##  echo "Stored params..."
##  env | grep 'PARAM_'
##  echo "--------------"
#
#  ARGS=$(env | grep 'PARAM_' | cut -d'=' -f1)
#  echo "$ARGS" | sort
#  SHORT_ARGS=$(echo "$ARGS" | grep "^PARAM_.*_SHORT$")
#  SHORT_ARGS=$(echo "$SHORT_ARGS" | sort)
#  echo "$SHORT_ARGS
#  -----"
#  LONG_ARGS=$(echo "$ARGS" | grep "^PARAM_.*_LONG$")
#  LONG_ARGS=$(echo "$LONG_ARGS" | sort)
#  echo "$LONG_ARGS
#  -----"
#
#
#  TOTAL_PARAMS=$(($#/2))
#  echo "Count: $TOTAL_PARAMS"
##  echo "$*"
#
##  while IFS= read -r line; do
##    val=$(eval 'echo $'$line)
##    echo "val: $val"
##  done <<< "$SHORT_ARGS"
#
#  while [[ $# -gt 0 ]]; do
#    echo "$1" | grep '=' > /dev/null
#    if [[ $? -eq 0 ]]; then
#      echo "$1"
#      shift 1
#    else
#      echo "$1 $2"
#      shift 2
#    fi
#  done
#}
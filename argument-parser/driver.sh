#!/usr/bin/env bash

. ./arg-parser-v2.sh

#export PARAM_CONFIG_FILE_VALUE=./arg-parser-test.config

process_parameter \
  -p1 parameter11 \
  -p2=parameter12 \
  -p3 parameter13 \
  --parameter4 parameter14 \
  --parameter5=parameter15 \
  --parameter6 parameter16

#!/bin/bash
#
# A dummy application that writes its pid to a file and just loops.
#
# Connor Imes
# 2018-09-18
#

PID_FILE="$1"

if [ -z "$1" ]; then
  echo "Usage: $0 <pid_file>" > /dev/stderr
  exit 1
fi

echo $$ > "${PID_FILE}"
while true; do
  echo "Dummy application is running..."
  sleep 1
done

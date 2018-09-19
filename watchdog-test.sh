#!/bin/bash
#
# Test the watchdog daemon's ability to track PIDs.
# This script must be run as root.
#
# Connor Imes
# 2018-09-18
#

DUMMY_APP_PID_FILE="/var/run/dummy.pid"
WATCHDOG_PID_FILE="/var/run/watchdog.pid"

# File location depends on Linux distribution
SYSLOG_FILE="/var/log/syslog"
if [ ! -e "${SYSLOG_FILE}" ]; then
  SYSLOG_FILE="/var/log/messages"
fi

# Launch dummy application to be monitored
./dummy.sh "${DUMMY_APP_PID_FILE}" &
sleep 1

# Start the watchdog daemon, but disable reboot since this is a test
# Reboot is disabled by not actually opening the /dev/watchdog file
watchdog --config-file watchdog.conf --no-action --verbose

# Check syslog for watchdog status
tail -F "${SYSLOG_FILE}" | grep watchdog &
tailpid=$!
for i in $(seq 1 10); do
  sleep 1
done

# Stop dummy application
echo "Stopping dummy application, watchdog should fail to ping it now"
kill $(cat "${DUMMY_APP_PID_FILE}")
for i in $(seq 1 10); do
  sleep 1
done

# Stop log monitor
kill $tailpid

# Stop watchdog service
kill $(cat "${WATCHDOG_PID_FILE}")

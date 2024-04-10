#!/bin/bash
sleep 5
echo "---Starting connected containers watchdog on ${CONNECTED_CONTAINERS}---"
nc ${CONNECTED_CONTAINERS%%:*} ${CONNECTED_CONTAINERS#*:}
EXIT_STATUS=$?

if [ "${EXIT_STATUS}" == 1 ]; then
  echo "---Couldn't connect to: ${CONNECTED_CONTAINERS%%:*} on port: ${CONNECTED_CONTAINERS#*:}"
  exit 1
else
  echo "---Connection to connected container: ${CONNECTED_CONTAINERS} lost, restarting in 5 seconds...---"
  sleep 5
  kill -SIGTERM $(pidof sleep)
fi
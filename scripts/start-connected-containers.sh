#!/bin/bash
# Check if variable is set correctly
if [ -z "${CONNECTED_CONTAINERS%%:*}" ] || [ -z "${CONNECTED_CONTAINERS#*:}" ] || [[ "${CONNECTED_CONTAINERS}" != *:* ]]; then
  echo "---The variable CONNECTED_CONTAINERS is not set properly!---"
  echo "---Please set it like: 127.0.0.1:27286---"
  exit 1
fi

# Wait 5 seconds to start the connection and try to connect 5 times
sleep 5
echo "---Starting connected containers watchdog on ${CONNECTED_CONTAINERS}---"
while [ $tries -lt 5 ]; do
  nc ${CONNECTED_CONTAINERS%%:*} ${CONNECTED_CONTAINERS#*:}
  if [ $? -eq 0 ]; then
    break
  else
    echo "---Connection attempt $((tries + 1)) failed, rytring in 5 seconds..."
    tries=$((tries + 1))
    sleep 5
  fi
done

# Determin on exit status if connection was successfull or if container should be restarted
if [ $tries -eq 5 ]; then
  echo "---Couldn't connect to: ${CONNECTED_CONTAINERS%%:*} on port: ${CONNECTED_CONTAINERS#*:} after 5 tries!---"
  exit 1
else
  echo "---Connection to connected container: ${CONNECTED_CONTAINERS} lost, restarting in 10 seconds...---"
  sleep 10
  kill -SIGTERM $(pidof sleep)
fi
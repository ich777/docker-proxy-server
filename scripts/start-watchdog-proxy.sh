#!/bin/bash
sleep 5
killpid="$(pidof proxy)"

while true
do
	tail --pid=$killpid -f /dev/null
	kill -SIGTERM $(pidof tail)
    echo "---Proxy crashed, restarting container!---"
	exit 0
done
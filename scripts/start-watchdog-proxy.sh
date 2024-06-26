#!/bin/bash
killpid="$(pidof proxy)"

while true
do
	tail --pid=$killpid -f /dev/null
	kill -SIGTERM $(pidof sleep)
    echo "---Proxy crashed, restarting container!---"
	exit 0
done
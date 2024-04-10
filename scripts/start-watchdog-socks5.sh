#!/bin/bash
killpid="$(pidof socks5)"

while true
do
	tail --pid=$killpid -f /dev/null
	kill -SIGTERM $(pidof sleep)
    echo "---SOCKS5 crashed, restarting container!---"
	exit 0
done
#!/bin/bash
sleep 5

killpid="$(pidof socks5)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof tail)"
    echo "---SOCKS5 crashed, restarting container!---"
	exit 0
done
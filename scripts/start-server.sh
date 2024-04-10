#!/bin/bash
if [ "${HTTP_PROXY}" == "true" ]; then
  if [ ! -z "${HTTP_PROXY_USER}" ]; then
    if [ -z "${HTTP_PROXY_PWD}" ]; then
      echo "---Proxy user set but no password set! Please set a password!---"
      echo "---Putting container into sleep mode...---"
      sleep infinity
    fi
    if [[ ! ${HTTP_PROXY_PWD} =~ ^[a-zA-Z0-9+-_~?#/.{}:,]+$ ]]; then
      echo "---Your password contains at least one not allowed character!---"
      echo "Allowed characters are: ?#/[]{}.:,/-_~-+"
      echo "---Putting container into sleep mode...---"
      sleep infinity
    fi
    HTTP_PROXY_PWD="$(echo -n "${HTTP_PROXY_PWD}" | jq -sRr @uri)"
    HTTP_AUTH="-auth static://?username=${HTTP_PROXY_USER}&password=${HTTP_PROXY_PWD}"
  fi
  HTTP_PROXY_OPTIONS="${HTTP_PROXY_PORT}${HTTP_AUTH:+ }${HTTP_AUTH}${HTTP_PROXY_EXTRA:+ }${HTTP_PROXY_EXTRA}"
  echo "---Starting http proxy server${HTTP_AUTH:+ with authentication enabled}---"
  /usr/bin/proxy -bind-address :${HTTP_PROXY_OPTIONS} &
  unset HTTP_PROXY_USER
  unset HTTP_PROXY_PWD
  unset HTTP_AUTH
  unset HTTP_PROXY_OPTIONS
  /opt/scripts/start-watchdog-proxy.sh &
else
  echo "---http/https proxy disabled---"
fi

if [ "${SOCKS5_PROXY}" == "true" ]; then
  if [ ! -z "${SOCKS5_PROXY_USER}" ]; then
    if [ -z "${SOCKS5_PROXY_PWD}" ]; then
      echo "---SOCKS5 user set but no password set! Please set a password!---"
      echo "---Putting container into sleep mode...---"
      sleep infinity
    fi
    if [[ ! ${SOCKS5_PROXY_PWD} =~ ^[a-zA-Z0-9+-_~?#/.{}:,]+$ ]]; then
      echo "---Your password contains at least one not allowed character!---"
      echo "Allowed characters are: ?#/[]{}.:,/-_~-+"
      if [ "${HTTP_PROXY}" == "true" ]; then
        kill $(pidof proxy)
      fi
      echo "---Putting container into sleep mode...---"
      sleep infinity
    fi
    SOCKS5_AUTH="-user ${SOCKS5_PROXY_USER} -pwd ${SOCKS5_PROXY_PWD}"
  fi
  SOCKS5_PROXY_OPTIONS="-p ${SOCKS5_PROXY_PORT}${SOCKS5_AUTH:+ }${SOCKS5_AUTH}${SOCKS5_PROXY_EXTRA:+ }${SOCKS5_PROXY_EXTRA}"
  echo "---Starting SOCKS5 proxy${SOCKS5_AUTH:+ with authentication enabled}---"
  /opt/scripts/
  /usr/bin/socks5 ${SOCKS5_PROXY_OPTIONS} &
  unset SOCKS5_PROXY_USER
  unset SOCKS5_PROXY_PWD
  unset SOCKS5_AUTH
  unset SOCKS5_PROXY_OPTIONS
  /opt/scripts/start-watchdog-socks5.sh &
else
  echo "---SOCKS5 proxy disabled---"
fi

sleep infinity

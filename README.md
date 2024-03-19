# Proxy-Server in Docker optimized for Unraid
This container is a dedicated http/https and SOCKS5 proxy both with authentication support.  
It's intended usecase is to use it in combination with a VPN container to give your applications outside of your server access to the VPN.

If you VPN supports native Wireguard support:
1. Go to the built in VPN Manager in the Settings tab in Unraid
2. Import the configuration vrom your VPN provider
3. Make sure that "Peer type of access" is set to "VPN tunneled access for docker"
4. Change the slider to active
5. Set the network from this container to the `wg:` network from your provider

To connect the container to a already installed VPN container:
1. Set the `Network Type` in this Docker template to `None`
2. Enable the Advanced View on the top right corner from this Docker template and append:
`--net=container:CONTAINERNAME`  
To the Extra Parameters (you have to change `CONTAINERNAME` to the VPN Docker container name eg: `--net=container:binhex-delugevpn` when the VPN Docker container name is `binhex-delugevpn` - case sensitive!).
3. Go to the VPN Docker template and create two new port mappings with the button `Add another Path, Port, Variable, Label or Device`, by default 8118 (for http/https proxy) and 1030 (for SOCKS5 proxy) both TCP protocol and with host/container port set to the same port.
4. When you've done that you can connect the application(s) to the proxy to the host IP from the VPN Docker container, by default with 8118 (for http/https proxy) and 1030 (for SOCKS5 proxy)

**Note for Firefox and Chrome:** Firefox and Chrome natively don't support authentication for a SOCKS5 proxy, it is recommended to use a extension like FoxyProxy supports authentication).

**URL encode:** If you are using a password with special charcters and want to use the http/https proxy system wide, the container ships with `urlencode` to convert your password to a URL compatible format. Just open up a terminal from the container, issue `urlencode` and follow the prompts.

The container uses [dumbproxy](https://github.com/SenseUnit/dumbproxy) and [socks5](https://github.com/jqqjj/socks5) (both written in golang) as a backend to serve http/https and SOCKS5 proxy.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| HTTP_PROXY | Enable or disable http/https proxy | true |
| HTTP_PROXY_USER | User for http/https proxy (leave empty for no authentication) | none |
| HTTP_PROXY_PWD | Password for http/https proxy (Not all special characters are allowed, please see the log if the container catches a non allowed character). Allowed special characters are: ?#/[]{}.:,/-_~-+ | none |
| SOCKS5_PROXY | Minimum of 768 pixesl (leave blank for 768 pixels) | true |
| SOCKS5_PROXY_USER | User for SOCKS5 proxy (leave empty for no authentication) | none |
| SOCKS5_PROXY_PWD | Password for SOCKS5 proxy (Not all special characters are allowed, please see the log if the container catches a non allowed character). Allowed special characters are: ?#/[]{}.:,/-_~-+ | none |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Set permissions for newly created files | 0000 |

## Run example
```
docker run --name Proxy-Server -d \
	-p 8118:8118 \
	--env 'HTTP_PROXY=true' \
	--env 'SOCKS5_PROXY=true' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--restart=unless-stopped\
	ich777/proxy-server
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

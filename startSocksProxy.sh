#!/usr/bin/env /bin/bash
# (C) Lilian BESSON
# http://besson.qc.to/bin/startSocksProxy.sh

# The domain to connect with
dom="${1:-ssh2.crans.org}"
shift

# The username to use
login="${1:-besson}"
shift

echo -e "Starting SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ... (press Enter to continue)"
read
xfce4-terminal --title="SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ..." --command="ssh -p 443 -v -D 23456 -N ${login}@${dom} | tee /tmp/startSocksProxy.log" &

echo -e "Now you can enable the SOCKS v5 Proxy from Firefox's preferences : \nEdition\n > Preferences\n > Advanced\n > Network\n > Connexion : Parameters\n > Manually configured the proxy\n > SOCKS host\n > 127.0.0.1 with Port : 23456 (and toggle SOCKS v5)."
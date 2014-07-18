#!/usr/bin/env /bin/bash
# (C) Lilian BESSON
# http://besson.qc.to/bin/proxy.sh

dom="${1:-zamok}"
shift
url="${2:-monip.org}"

echo "Starting SOCKS v5 Proxy : port:23456 host:${dom}.crans.org ... (press Enter to continue)"
read
xfce4-terminal --title="SOCKS v5 Proxy : port:23456 host:${dom}.crans.org ..." --command="ssh -v -D 23456 -N besson@${dom}.crans.org" &

echo "Starting Firefox with tsocks... (press Enter to continue)"
read
tsocks firefox -new-instance "${url}"
#!/usr/bin/env /bin/bash
# (C) Lilian BESSON
# http://besson.qc.to/bin/proxy.sh

dom="${1:-zamok}"

echo "Starting SOCKS v5 Proxy : port:23456 host:${dom}.crans.org ..."
read
gnome-terminal --title "SOCKS v5 Proxy : port:23456 host:${dom}.crans.org ..." --command "ssh -v -D 23456 -N besson@\"$dom\".crans.org" &

echo "Starting Firefox with tsocks..."
read
tsocks firefox -new-instance http://monip.org/
#!/usr/bin/env /bin/bash
# (C) Lilian BESSON
# http://besson.qc.to/bin/proxy.sh

# The domain to connect with
dom="${1:-zamok.crans.org}"
shift

# The username to use
login="${1:-besson}"
shift

# The command to launch
mycommand="${1:-firefox}"
shift

# The args to pass to the command
args="${@:-monip.org}"

echo -e "Starting SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ... (press Enter to continue)"
read
xfce4-terminal --title="SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ..." --command="ssh -p 443 -v -D 23456 -N ${login}@${dom}" &

echo -e "Starting ${mycommand} with tsocks... (press Enter to continue)"
read

# tsocks firefox -new-instance "${args}"
tsocks "${mycommand}" "${args}"

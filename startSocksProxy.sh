#!/usr/bin/env /bin/bash
# (C) Lilian BESSON
# http://besson.qc.to/bin/startSocksProxy.sh

# Sources: http://blog.uggy.org/post/2006/04/22/87-tsock-pour-tout-rendre-compatible-socks
# and: http://blog.uggy.org/post/2006/04/22/86-tunnel-ssh-avec-l-option-d

# The domain to connect with
# dom="${1:-ssh2.crans.org}"
dom="${1:-ssh.crans.org}"
shift

# The username to use
login="${1:-besson}"
shift

# Start the proxy only if required
if [[ $(grep "login:${login} port:23456 host:${dom}" /tmp/startSocksProxy.list 2>/dev/null) ]]; then
    echo -e "This SOCKS v5 Proxy  : login:${login} port:23456 host:${dom} is already running (according to /tmp/startSocksProxy.list)."
else
    echo -e "Starting SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ... (press Enter to continue)"
    # read
    # xfce4-terminal --title="SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ..." --command="ssh -p 443 -v -D 23456 -N ${login}@${dom} | tee /tmp/startSocksProxy.log || mv -f /tmp/startSocksProxy.list /tmp/startSocksProxy.list~" || mv -f /tmp/startSocksProxy.list /tmp/startSocksProxy.list~ &
    xfce4-terminal --title="SOCKS v5 Proxy : login:${login} port:23456 host:${dom} ..." --command="ssh -v -D 23456 -N ${login}@${dom} | tee /tmp/startSocksProxy.log || mv -f /tmp/startSocksProxy.list /tmp/startSocksProxy.list~" || mv -f /tmp/startSocksProxy.list /tmp/startSocksProxy.list~ &
    echo -e "login:${login} port:23456 host:${dom}" >> /tmp/startSocksProxy.list
fi

echo -e "Now you can enable the SOCKS v5 Proxy from Firefox's preferences : \nEdition\n > Preferences\n > Advanced\n > Network\n > Connexion : Parameters\n > Manually configured the proxy\n > SOCKS host\n > 127.0.0.1 with Port : 23456 (and toggle SOCKS v5)."
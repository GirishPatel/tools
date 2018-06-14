#!/usr/bin/env zsh

# USAGE
# Create two files to use these functions:
# 1. config_file
#   export TEST_HOST=<any_remote_hostname> # for dns resolution check
#   export VPN_KEY=<vpn_key>
#   export VPN_NAME=<vpn_name>
#   export PASS_FILE=<tmp_pass_file>
#   export LOG_FILE=<log_file>
#   export POLL_TIME=<vpn_check_poll_time_sec>
#   export STOP_FILE=<touch_stop_file>
#
# 2. run_script: ~/bin/connect_vpn                                                                                                         [0][0 sec]
#   !/usr/bin/env zsh
#   source <config_file>
#   source /path_to_project/tools/cli/connect_vpn.sh 
#   poll_vpn 2>>$LOG_FILE >>$LOG_FILE
#
# Start continuous vpn run: ~/bin/connect_vpn
# Stop vpn: touch <STOP_FILE>
# 

function connect_vpn {

    ping -c 1 -W 1 $TEST_HOST 

    if [[ $? -eq 2 ]]; then
        notify-send -t 2000 "VPN Connecting" "VPN disconnected, connecting again ..."
        oathtool --totp -b $VPN_KEY | xargs -I PIN echo vpn.secrets.password:PIN > $PASS_FILE
        nmcli connection up $VPN_NAME passwd-file $PASS_FILE
    fi
}

function poll_vpn {
    isContinue=1
    while [[ $isContinue -eq 1 ]];
    do
        connect_vpn
        sleep $POLL_TIME # sec
        if [[ -a $STOP_FILE ]]; then
            echo "Stopping VPN"
            isContinue=0
            nmcli connection down $VPN_NAME
            rm $STOP_FILE
        fi
    done
}


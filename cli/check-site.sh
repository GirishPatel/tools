#!/usr/bash

website=$1
count=$2
timeout=$3

if [[ -z $website ]]; then
    echo "Usage: $0 <ping_count> <ping_timeout> <website>"
    exit 1
fi

count=${count:-1}
timeout=${timeout:-1}

ping -c $count -t $timeout $website > /dev/null
s=$?

if [[ $s -eq 0 ]]; then
    msg "$website working"
fi


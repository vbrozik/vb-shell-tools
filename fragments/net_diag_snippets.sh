#!/bin/sh

# Collection of network diagnostic snippets

exit 0
# shellcheck disable=SC2317  # The file is not to be executed.
if false ; then


# ARP-scan a C network on a given interface
# alternative: sh -c ... $(seq 1 254) ...

interface=bond5.123
ip_prefix=10.11.12
bash -c "
    for octet4 in {1..254} ; do
        arping -c1 -I '$interface' '$ip_prefix'\$octet4 |
            grep -F 'reply from' &
        sleep 0.005
    done"


interface=bond5.123
ip_prefix=10.11.12
ip neigh flush dev "$interface"
bash -c "
    for octet4 in {1..254} ; do
        ping -c1 '$ip_prefix'\$octet4 | grep -F ' from ' &
        sleep 0.005
    done"
ip neigh list dev "$interface" |
    grep -Ev '(FAILED|INCOMPLETE)$' | sort


fi

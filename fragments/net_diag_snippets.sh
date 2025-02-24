#!/bin/sh

# Collection of network diagnostic snippets

exit 0
# shellcheck disable=SC2317  # The file is not to be executed.


# ARP scan using arping

sh -c '
    for octet4 in $(seq 1 254) ; do
        arping -c1 -I bond2.3380 10.127.50.$octet4 |
            grep -F "reply from" &
            sleep 0.005
    done'

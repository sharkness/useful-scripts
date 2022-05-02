#!/bin/bash
# @Function
# show count of tcp connection.
#
# @Usage
#   $ ./count-tcp-connection
set -eEuo pipefail

# NOTE: DO NOT declare var PROG as readonly in ONE line!
PROG="$(basename "$0")"
readonly PROG
readonly PROG_VERSION='2.5.0-dev'

################################################################################
# util functions
################################################################################

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION]...
show count of tcp connection
Example:
    ${PROG}
Options:
    -h, --help      display this help and exit
    -V, --version   display version information and exit
EOF
    exit
}

progVersion() {
    echo "$PROG $PROG_VERSION"
    exit
}

################################################################################
# parse options
################################################################################

for a; do
    [[ "-h" == "$a" || "--help" == "$a" ]] && usage
done

for a; do
    [[ "-V" == "$a" || "--version" == "$a" ]] && progVersion
done

################################################################################
# biz logic
################################################################################

# On MacOS, netstat need to using -p tcp to get only tcp output.
uname | grep Darwin -q && option_for_mac="-ptcp"
# @todo: check compatibility for Monterey+

netstat -tna ${option_for_mac:-} | awk 'NR > 2 {
    ++s[$NF]
}
END {
    # get max length of stat and count
    for(v in s) {
        stat_len = length(v)
        if(stat_len > max_stat_len) max_stat_len = stat_len
        count_len = length(s[v])
        if (count_len > max_count_len) max_count_len = count_len
    }
    for(v in s) {
        printf "%-" max_stat_len "s %" max_count_len "s\n", v, s[v]
    }
}' | sort -nr -k2,2

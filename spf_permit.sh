#!/bin/bash
#
#*****************************************************************
#     spf_permit - equk.co.uk
#*****************************************************************
# This script lists IP addresses from a domains SPF records
# Also supports lists included in TXT records for domain
# Output can be pasted into whitelist file
# eg: /etc/postfix/postscreen_access.cidr
#*****************************************************************
# Copyright (c) 2016 B.Walden.  All rights reserved.
# LICENSE: MIT (LICENSE file should be included with script)

# COLORS

blue="\033[1;34m"
green="\033[1;32m"
red="\033[1;31m"
bold="\033[1;37m"
reset="\033[0m"

# VARIABLES

initial_domain=$1
day=$(date '+%d/%m/%Y')
gplus="[$green+$reset]"
bplus="[$blue+$reset]"

# MAIN FUNCTION

spf_lookup() {
    echo -e "# ${1}"
    # lookup txt entries for given domain
    dig +short txt "$1" |
        # format output
        tr ' ' '\n' |
        while read entry; do
            case "$entry" in
            # if ipv4 found output it
            ip4:*) echo ${entry#*:} ;;
            # if ipv6 found output it
            ip6:*) echo ${entry#*:} ;;
            # if another spf list found loop function
            include:*) spf_lookup ${entry#*:} ;;
            esac
        done
}

if [ $# -eq 0 ]; then
    echo -e "$red ERROR:$reset no arguments specified"
    echo -e "Please provide a domain to lookup"
    exit 0
fi

# OUTPUT TEXT

echo -e ""
echo -e "# ${initial_domain}"
echo -e "## ${day}"
echo -e ""

# EXECUTE MAIN FUNCTION

spf_lookup ${1} | sed s/$/'   permit'/
echo -e ""

#!/bin/bash

# fhutchinson@encompass.tv
# 2019-09
# Get AWS security rules
# Requires jq to be installed

DIR="$(dirname "$0")" # assumes no spaces in the directory

for CONFIG in $DIR/conf.d/*;
do
    echo $(basename $CONFIG)
    . $CONFIG
    aws ec2 describe-security-groups --group-id $SECURITY_ID \
	| jq -r ".SecurityGroups[0].IpPermissions[0].IpRanges[] | ([.CidrIp, .Description] | @csv)"
    echo # newline
done

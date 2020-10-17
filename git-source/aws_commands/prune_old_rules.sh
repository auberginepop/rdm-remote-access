#!/bin/bash

# fhutchinson@encompass.tv
# 2019-09
# Get AWS security rules and remove ones older than retention perios
# Format returned by rule_getall.sh will be "1.1.1.1/32","2019-09-25_s"

DIR="$(dirname "$0")" # assumes no spaces in the directory

for CONFIG in $DIR/conf.d/*
do
    . $CONFIG
    EXPIRATION_DATE=$(date +%F -d "$RETENTION_PERIOD days ago")
    while IFS= read -r LINE
    do
	IP=$(echo $LINE|cut -d \" -f 2)
	DESCRIPTION=$(echo $LINE|cut -d \" -f 4)
	DATE=$(echo $DESCRIPTION|cut -c -10)
	if [[ $DATE < $EXPIRATION_DATE ]]
	then
	    if aws ec2 revoke-security-group-ingress --group-id $SECURITY_ID --protocol $PROTOCOL --port $PORT --cidr $IP
	    then
		echo "$(date "+%F %T") deleting rule for $IP - $DESCRIPTION" >> $LOG
	    else
		echo "$(date "+%F %T") error when deleting rule for $IP - $DESCRIPTION" >> $LOG
	    fi
	fi
    done < <(aws ec2 describe-security-groups --group-id $SECURITY_ID \
	| jq -r ".SecurityGroups[0].IpPermissions[0].IpRanges[] | ([.CidrIp, .Description] | @csv)")
done

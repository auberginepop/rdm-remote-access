#!/bin/bash

# fhutchinson@encompass.tv
# 2019-09
# add IP to an AWS security rule (if it exists replace to the description is updated)

IP="$1"
DESCRIPTION="$2"
DIR="$(dirname "$0")" # assumes no spaces in the directory

for CONFIG in $DIR/conf.d/*;
do
    . $CONFIG

    #delete existing rule if it exists. Dump stderr as it will error if the rule did not exists
    aws ec2 revoke-security-group-ingress --group-id $SECURITY_ID --protocol $PROTOCOL --port $PORT --cidr $IP/32 2>/dev/null

    # Add new rule
    aws ec2 authorize-security-group-ingress \
	--group-id $SECURITY_ID \
	--ip-permissions IpProtocol=$PROTOCOL,FromPort=$PORT,ToPort=$PORT,IpRanges="[{CidrIp=$IP/32,Description=$DESCRIPTION}]" \
	|| exit 1

    echo "$(date "+%F %T") rule added for $IP - $DESCRIPTION" >> $LOG
done

exit 0

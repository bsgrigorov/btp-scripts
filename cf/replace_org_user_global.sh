#!/bin/bash
# Input:
# $1: global account id
# $2: file name csv with subaccounts
# # run
# sh filename.sh global-account-id csv-file


GLOBAL_ACCOUNT=$1
INPUT=csv/$2.csv

if [ "$1" == "production" ]; then
    source credentials/prod.sh
    echo "Prod creds"
else
    source credentials/nonprod.sh
    echo "Non prod creds"
fi

btp login --subdomain $GLOBAL_ACCOUNT --user $PUSER --password $PASSWORD --url https://cpcli.cf.eu10.hana.ondemand.com

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read subaccount
do
	echo "SA : $subaccount"
    sh cf/replace_org_user.sh $GLOBAL_ACCOUNT $subaccount

done < $INPUT
IFS=$OLDIFS
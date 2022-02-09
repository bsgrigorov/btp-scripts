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

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read subaccount
do
	echo "SA : $subaccount"
    btp login --subdomain $GLOBAL_ACCOUNT --user $PUSER --password $PASSWORD --url https://cpcli.cf.eu10.hana.ondemand.com
    btp unassign security/role-collection "Subaccount Administrator" --from-user $USER_EMAIL -sa $subaccount

done < $INPUT
IFS=$OLDIFS
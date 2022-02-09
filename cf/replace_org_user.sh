#!/bin/bash

GLOBAL_ACCOUNT=$1
subaccount=$2

if [ "$1" == "production" ]; then
    source credentials/prod.sh
else
    source credentials/nonprod.sh
fi

function reverse_users {
    USER_EMAIL_TEMP=$USER_EMAIL_OLD
    USER_EMAIL_OLD=$USER_EMAIL
    USER_EMAIL=$USER_EMAIL_TEMP
    PUSER_TEMP=$PUSER_OLD
    PUSER_OLD=$PUSER
    PUSER=$PUSER_TEMP
    PASSWORD_TEMP=$PASSWORD_OLD
    PASSWORD_OLD=$PASSWORD
    PASSWORD=$PASSWORD_TEMP
}

btp login --subdomain $GLOBAL_ACCOUNT --user $PUSER --password $PASSWORD --url https://cpcli.cf.eu10.hana.ondemand.com

btp_envs=$(btp --format=json list accounts/environment-instance -sa $subaccount)

env_count=$(echo $btp_envs | jq '.environmentInstances | length')

if [ "$env_count" = "1" ]; then
    org_name=$(echo $btp_envs  | jq '.environmentInstances[0].labels | fromjson | ."Org Name:"' | tr -d \")
    api_endpoint=$(echo $btp_envs  | jq '.environmentInstances[0].labels | fromjson | ."API Endpoint:"' | tr -d \")
    org_id=$(echo $btp_envs  | jq '.environmentInstances[0].labels | fromjson | ."Org ID:"' | tr -d \")

    # reverse_users

    cf login -a $api_endpoint -o $org_name -u $PUSER_OLD -p $PASSWORD_OLD
    if ! cf set-org-role $USER_EMAIL $org_name OrgManager | grep -q 'FAILED'; then
        cf spaces | tail -n +4 | while read space; do
            cf set-space-role $USER_EMAIL $org_name $space SpaceManager
            cf set-space-role $USER_EMAIL $org_name $space SpaceDeveloper
            cf unset-space-role $USER_EMAIL_OLD $org_name $space SpaceManager
            cf unset-space-role $USER_EMAIL_OLD $org_name $space SpaceDeveloper
        done

        if cf unset-org-role $USER_EMAIL_OLD $org_name OrgManager | grep -q 'FAILED'; then
            echo "FAILED to unset org user $USER_EMAIL_OLD in org $org_name"
        else
            echo "SUCCESS Org: $org_name $api_endpoint"
        fi
    else 
        echo "FAILED to set org user $USER_EMAIL in org $org_name. Skipping unset"
    fi
else
    echo "Skipping no CF"
fi

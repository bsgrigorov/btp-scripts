GLOBAL_ACCOUNT=$1

if [ "$1" == "production" ]; then
    source credentials/prod.sh
    echo "Prod creds"
else
    source credentials/nonprod.sh
    echo "Non prod creds"
fi


btp login --subdomain $GLOBAL_ACCOUNT --user $PUSER --password $PASSWORD --url https://cpcli.cf.eu10.hana.ondemand.com

btp list accounts/subaccounts | tail -n +5 | ghead -n -1 | while IFS=" " read subaccount rest
do
    echo $subaccount >> csv/$2.csv
done 

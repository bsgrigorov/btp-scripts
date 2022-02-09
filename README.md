# BTP CLI for Subaccount management
This is used for managing users in subaccounts. This was used during a p-user securuty incident we experienced with a leaked credential.

## Requirements to run
- [btp cli](https://help.sap.com/viewer/65de2977205c403bbc107264b8eccf4b/Cloud/en-US/8a8f17f5fd334fb583438edbd831d506.html)
- [cf cli](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
- `brew install coreutils`
- Copy the [credentials.sh](credentials.sh) file into folder `credentials` and add the credentials to it. Name 2 files `prod.sh` and `nonprod.sh`.

## Manual steps performed by scripts
Replacing users in cf org reference: https://wiki.wdf.sap.corp/wiki/display/Eureka/Change+the+bss+global+account+user+guide

## How to run
### Get subaccount IDs
```
sh cf/list_subaccounts.sh <global-account-id> <csv-file-name-without-extension>
```

#### Output
CSV files in [csv](csv) folder.

### Replace org user
Example execution
```shell
sh cf/replace_org_user_global.sh <global-account-id> <csv-file-name-without-extension> >> <log-file-name>.log
```

Note: `global account id` must correspond to the correct `csv file name`

#### Output
These scripts were run for 5 subaccounts and the outputs are in [log](log) folder.

### Replace subaccount permissions
```
sh sh/assign.sh <global-account-id> <input-csv-without-extension>
sh sh/unassign.sh <global-account-id> <input-csv-without-extension>
sh sh/delete.sh <global-account-id> <input-csv-without-extension>
```

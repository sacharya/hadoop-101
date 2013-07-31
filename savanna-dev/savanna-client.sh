#!/bin/bash

export OS_USERNAME=demo

export OS_TENANT_NAME=demo

if [[ -z "$TENANT_ID" ]]; then 
    export TENANT_ID=`keystone token-get | grep 'tenant_id' | awk '{print $4}'`
fi

if [[ -z "$TOKEN_ID" ]]; then
    export TOKEN_ID=`keystone token-get | grep ' id' | awk '{print $4}'`
fi 

case "$1" in
"list")
    http http://localhost:8386/v1.0/$TENANT_ID/clusters X-Auth-Token:$TOKEN_ID
    ;;
"create")
    http http://localhost:8386/v1.0/$TENANT_ID/clusters X-Auth-Token:$TOKEN_ID < create.json 
    ;;
"delete")
    http DELETE http://localhost:8386/v1.0/$TENANT_ID/clusters/$2 X-Auth-Token:$TOKEN_ID
    ;;
*)
    echo "list"
    echo "create"
    echo "delete <id>"
    ;;
esac


#!/bin/bash
DATE=$(date +"%Y%m%d%H%M")
# Function to get get entities and aliases from all namespaces recursively
list_alias() {
    local namespace=$1
    # List child namespaces
    local child_namespaces=$(vault namespace list -namespace=${namespace} -format=json | jq -r '.[]')

    # Recurse into each child namespace
    for child in $child_namespaces; do
       list_alias "${namespace}/${child}"
    done

    #  List all entity aliases
    echo "looking into namespace: ${namespace}"
   # local canonical_ids=$(vault list -format=json -detailed identity/entity-alias/id| jq -r '.data.key_info[].canonical_id')
    
    # echo \"$namespace\":$(vault list -format=json -detailed -namespace=$(echo $namespace) identity/entity-alias/id), >> entity_alias_$DATE.json
    echo $(vault list -format=json -detailed -namespace=$(echo $namespace) identity/entity-alias/id), >> entity_alias_$DATE.json
    
    local canonical_ids=$(vault list -format=json -detailed -namespace=$(echo $namespace) identity/entity-alias/id | jq -r '.data.key_info[].canonical_id')
    # If number of elements of array is nonzero, then recurse into namespace
  if [ ${#canonical_ids[*]} -gt 0 ] ; then
  #echo -e \"$namespace\": >> entities_$DATE.json
    for id in ${canonical_ids[*]} ; do 
      entity=$(vault read -format=json -namespace=$(echo $namespace) identity/entity/id/$id | jq . )
      echo -e $entity , >> entities_$DATE.json
    done
    #echo , >> entities_$DATE.json
  fi

}

# Call the function to get entities and aliases
echo "[" >> entities_$DATE.json
echo "[" >> entity_alias_$DATE.json
list_alias "admin"
echo "{}" >> entity_alias_$DATE.json  
echo "]" >> entity_alias_$DATE.json  
echo "{}" >> entities_$DATE.json
echo "]" >> entities_$DATE.json

cat entities_$DATE.json | jq -r '.[].data.name'

 # vault list -format=json -detailed  identity/entity-alias/id | jq -r '.data.key_info | to_entries[] | .value.name'
 #  vault list -format=json -detailed  identity/entity-alias/id | jq -r '.data.key_info | to_entries[] | .value.name'

 vault read -address=$VAULT_ADDR -format=json sys/internal/counters/activity start_time="2023-01-01T00:00:00Z" end_time="2024-01-01T23:59:59Z" 

 vault read -address=$VAULT_ADDR -format=json sys/internal/counters/activity/export start_time="2023-01-01T00:00:00Z" end_time="2024-01-01T23:59:59Z" 

 vault read sys/internal/counters/activity/export start_time="2023-01-01T00:00:00Z" end_time="2024-01-01T23:59:59Z"  format=json


   curl \
    -H "X-Vault-Token: $(echo $VAULT_TOKEN)" \
    -H "X-Vault-Namespace: admin" \
    -X GET \
   $(echo $VAULT_ADDR)/v1/sys/internal/counters/activity


curl \
    -H "X-Vault-Token: $(echo $VAULT_TOKEN)" \
    -H "X-Vault-Namespace: admin" \
    -X GET \
   $(echo $VAULT_ADDR)/v1/sys/internal/counters/activity/export
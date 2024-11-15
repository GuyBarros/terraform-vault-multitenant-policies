#!/usr/bin/env bash
# This script constructs a JSON report of each namespace on a Vault cluster and
# its mounts and auth methods derived from the following endpoints:
#
# * [`/sys/mounts`](https://developer.hashicorp.com/vault/api-docs/system/mounts#list-mounted-secrets-engines)
# * [`/sys/auth`](https://developer.hashicorp.com/vault/api-docs/system/auth#list-auth-methods)
# * [`/sys/namespaces/:name`](https://developer.hashicorp.com/vault/api-docs/system/namespaces#read-namespace-information)
# 
# Requires `jq`, and a local `vault` binary.


# export VAULT_ADDR="http://localhost:8200"
# export VAULT_TOKEN=
export VAULT_FORMAT="json"

function root_ns_json {
# Contructs object containing mounts and auth methods inside root namespace

  mounts_json=$(vault read sys/mounts | jq '.data | {"mounts": .'})
  auth_json=$(vault read sys/auth | jq '.data | {"auth": .'})

  echo '{"custom_metadata": {}, "id": "root", "path": "/"}' | jq ". + $auth_json + $mounts_json"
}

function construct_ns_json {
# Takes target namespace as argument
  mounts_json=$(vault read -ns $1 sys/mounts | jq '.data | {"mounts": .}')
  auth_json=$(vault read -ns $1 sys/auth | jq '.data | {"auth": .}')

  # Removes last namespace segment to accomodate `sys/namespace/:name` API syntax
  vault read sys/namespaces/${1##*/} | jq ".data + $auth_json + $mounts_json"
}
  
function traverse_namespace {
# Recurse into nested namespaces, building JSON object containing mounts and auth methods

  # Create indexed array of namespaces
  namespacesList=($(vault list sys/namespaces | jq -r .[]))

  # If number of elements of array is nonzero, then recurse into namespace
  if [ ${#namespacesList[*]} -gt 0 ] ; then
    for ns in ${namespacesList[*]} ; do 
      ns_path=$(vault read sys/namespaces/$ns | jq -r .data.path)
      construct_ns_json ${ns_path%/} # Passes full namespace path while trimming trailing '/'
      VAULT_NAMESPACE=$ns_path traverse_namespace
    done
  fi
}

root_ns_json
traverse_namespace

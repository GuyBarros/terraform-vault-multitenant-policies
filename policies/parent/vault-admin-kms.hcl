# Manage namespaces in the root level
path "sys/namespaces/*" {
  capabilities = ["create", "update", "patch", "delete", "read", "list"]
}


# Create and manage identities (entities, aliases, lookup, identity tokens, OIDC)
path "identity/*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}

# Manage ACL policies in the root level
path "sys/policies/acl/*" {
  capabilities = ["read", "create", "update", "delete", "list"]
}

# List auth methods in the root level
path "sys/auth" {
  capabilities = ["read"]
}

# Enable, disable, and read auth methods in the root level
path "sys/auth/*" {
  capabilities = ["read", "create", "update", "delete", "sudo"]
}

# Configure Auth methods and CRUD Auth methods' roles in the root level
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Configure userpass, approle, etc.. auth methods
path "sys/mounts/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
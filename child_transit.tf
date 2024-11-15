resource "vault_mount" "transit" {
 for_each  = vault_namespace.children
  namespace = each.value.path_fq
  path                      = "${each.value.path_fq}_transit"
  type                      = "transit"
  description               = "Example description"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_transit_secret_backend_key" "key" {
  for_each = vault_mount.transit
  namespace = each.value.namespace
  backend = each.value.path
  name    = "my_key"
  deletion_allowed = true
}
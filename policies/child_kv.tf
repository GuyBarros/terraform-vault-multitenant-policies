
resource "vault_mount" "children" {
  for_each  = vault_namespace.children
  namespace = each.value.path_fq
  path      = "secrets"
  type      = "kv"
  options = {
    version = "1"
  }
}

resource "vault_generic_secret" "children" {
  for_each  = vault_mount.children
  namespace = each.value.namespace
  path      = "${each.value.path}/secret"
  data_json = jsonencode(
    {
      "ns" = each.key
    }
  )
}
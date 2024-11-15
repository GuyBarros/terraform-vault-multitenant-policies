
resource "vault_mount" "children" {
  for_each  = vault_namespace.children
  namespace = each.value.path_fq
  path      = "${each.value.path}_secrets"
  type      = "kv"
  options = {
    version = "2"
  }
}

resource "time_sleep" "wait_5_seconds" {
  depends_on = [vault_mount.children]

  create_duration = "5s"
}

resource "vault_kv_secret_v2" "example" {
  depends_on = [time_sleep.wait_5_seconds]
  for_each  = vault_mount.children
  namespace = each.value.namespace
  mount                      = each.value.path
  name                       = "test"
  data_json                  = jsonencode(
  {
    zip       = "zap",
    foo       = "bar"
  }
  )

}

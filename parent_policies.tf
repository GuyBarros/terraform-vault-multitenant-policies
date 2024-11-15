# resource "vault_policy" "admin-layer2-kms" {
#   name      = "admin-layer2-kms"
#   namespace = vault_namespace.parent.path
#   policy    = file("${path.module}/policies/parent/admin-layer2-kms.hcl")
# }

# resource "vault_policy" "admin-layer4" {
#   name      = "admin-layer4"
#   namespace = vault_namespace.parent.path
#   policy    = file("${path.module}/policies/parent/admin-layer4.hcl")
# }

# resource "vault_policy" "admin-layer5-app" {
#   name      = "admin-layer5-app"
#   namespace = vault_namespace.parent.path
#   policy    = file("${path.module}/policies/parent/admin-layer5-app.hcl")
# }

# resource "vault_policy" "root-admin" {
#   name      = "root-admin"
#   namespace = vault_namespace.parent.path
#   policy    = file("${path.module}/policies/parent/root-admin.hcl")
# }

resource "vault_policy" "vault-admin-kms" {
  name      = "vault-admin-kms"
  namespace = vault_namespace.parent.path
  policy    = file("${path.module}/policies/parent/vault-admin-kms.hcl")
}

resource "vault_policy" "admin-per-namespace" {
    for_each  = vault_namespace.children
   namespace = vault_namespace.parent.path
  name = "${each.value.path}_admin"
  policy = <<EOT
path "${each.value.path}/${each.value.path}_secrets" {
  capabilities = ["read","update","list","create","delete","sudo"]
}

path "kv/*" {
  capabilities = ["read","update","list","create","delete","sudo"]
}
EOT
}
# resource "vault_policy" "child-admin-layer2-kms" {
#     for_each  = vault_namespace.children
#   namespace = each.value.path_fq
#   name      = "admin-layer2-kms"
#   policy    = file("${path.module}/policies/parent/admin-layer2-kms.hcl")
# }

# resource "vault_policy" "child-admin-layer4" {
#     for_each  = vault_namespace.children
#   namespace = each.value.path_fq
#   name      = "admin-layer4"
#   policy    = file("${path.module}/policies/parent/admin-layer4.hcl")
# }

# resource "vault_policy" "child-admin-layer5-app" {
#     for_each  = vault_namespace.children
#   namespace = each.value.path_fq
#   name      = "admin-layer5-app"
#   policy    = file("${path.module}/policies/parent/admin-layer5-app.hcl")
# }

# resource "vault_policy" "child-root-admin" {
#     for_each  = vault_namespace.children
#   namespace = each.value.path_fq
#   name      = "root-admin"
#   policy    = file("${path.module}/policies/parent/root-admin.hcl")
# }

resource "vault_policy" "child-vault-admin-kms" {
    for_each  = vault_namespace.children
  namespace = each.value.path_fq
  name      = "vault-admin-kms"
  policy    = file("${path.module}/policies/parent/vault-admin-kms.hcl")
}

# resource "vault_policy" "child-vault-admin-secrets" {
#     for_each  = vault_namespace.children
#   namespace = each.value.path_fq
#   name      = "vault-admin-secrets"
#   policy    = file("${path.module}/policies/parent/vault-admin-secrets.hcl")
# }

resource "vault_identity_group" "child_admin_group" {
  for_each  = vault_namespace.children
  namespace = each.value.path_fq
  name     = "child_admin"
  type     = "internal"
  policies = ["default", "vault-admin-kms"]

  metadata = {
    version = "2"
  }

  member_group_ids = [vault_identity_group.parent_admin.id]

}


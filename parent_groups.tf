resource "vault_identity_group" "parent_admin" {
  name     = "parent_admin"
  namespace = vault_namespace.parent.path
  type     = "internal"
  policies = ["default", "ag_admin", "ab_admin", "gb_admin" ]

  metadata = {
    version = "2"
  }

  member_entity_ids = [vault_identity_entity.tf_user.id]
}

resource "vault_identity_entity" "tf_user" {
  namespace = vault_namespace.parent.path
  name = "tf_user"
}

resource "vault_identity_entity_alias" "test" {
  namespace = vault_namespace.parent.path
  name            = "tf_alias"
  mount_accessor  = data.vault_auth_backend.token.accessor
  canonical_id    = vault_identity_entity.tf_user.id
}

data "vault_auth_backend" "token" {
  path = "token"
  namespace = vault_namespace.parent.path
}


resource "vault_jwt_auth_backend" "jwt2" {
    namespace = vault_namespace.parent.path
    description         = "Demonstration of the Terraform JWT auth backend"
    path                = "jwt2"
    type = "jwt"
    jwt_validation_pubkeys = var.jwt_validation_pubkeys

}

resource "vault_jwt_auth_backend_role" "test2" {
  namespace = vault_namespace.parent.path
  backend         = vault_jwt_auth_backend.jwt2.path
  role_name       = "test-role"
  role_type       = "jwt"
  user_claim      = "email"
  token_policies  = ["default"]

  bound_claims= { project_id ="projecta,projectb" }
  groups_claim= "email"
    
}

resource "vault_identity_group" "jwt_group2" {
  namespace = vault_namespace.parent.path
  name     = "jwt_group2"
  type     = "external"
  policies = ["default", "ag_admin", "ab_admin", "gb_admin" ]

  metadata = {
    version = "2"
  }

  member_entity_ids = [vault_identity_entity.tf_user.id]
}
resource "vault_identity_group_alias" "jwt-group-alias2" {
  namespace = vault_namespace.parent.path
  name           = var.identifier
  mount_accessor = vault_jwt_auth_backend.jwt2.accessor
  canonical_id   = vault_identity_group.jwt_group2.id
}


resource "vault_identity_entity_alias" "jwt_user2" {
    namespace = vault_namespace.parent.path
  name            = var.identifier
  mount_accessor  = vault_jwt_auth_backend.jwt2.accessor
  canonical_id    = vault_identity_entity.jwt_user.id
}
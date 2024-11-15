variable "identifier" {
    description = "the indentifier used for entity and group alocation"
    default = "guy@hashicorp.com"
}
variable "jwt_validation_pubkeys" {
    description = "public key for offline jwt configuration, you can use JWT.io to generate the token and signing public keys"
    type = list(string)
    default = ["-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApxMkNXtG6GwTFzzny+af\nDVfrQdL1MMzMgxcjGOfMax7Go5+wf+iUh09Ep4EKyJQxwOMtZEMNNH11fKUcnTj/\nLEy92sVFdPLP4/+R0//DDdnmQo8RkYE6J1kSPrl1H44RBsuul23+sk29oruWb3bm\nydTpzfVeKUwy3Rzif82wbvA0ghP2sJ3eeJdI1HGDbYscPf+pmBhfcfuaIKfbcMcX\neaO18cIkiNz6xCa+4edN3jsqFSrLkssGl7ywI6phMO5qiAjElEpEsrKMEfpZwocI\nnU3qpYvcmHTK4z9Ra25DTGZtAdGDRT5cbMwyPlO9M0yct7BBJ8/7dAXy6PlqI7Mo\n5QIDAQAB\n-----END PUBLIC KEY-----"]

}

resource "vault_jwt_auth_backend" "jwt" {
    namespace = vault_namespace.parent.path
    description         = "Demonstration of the Terraform JWT auth backend"
    path                = "jwt"
    type = "jwt"
    jwt_validation_pubkeys = var.jwt_validation_pubkeys

}

resource "vault_jwt_auth_backend_role" "test" {
  namespace = vault_namespace.parent.path
  backend         = vault_jwt_auth_backend.jwt.path
  role_name       = "test-role"
  role_type       = "jwt"
  user_claim      = "email"
  token_policies  = ["default"]

  bound_claims= { project_id ="projecta,projectb" }
  groups_claim= "email"
    
}

resource "vault_identity_group" "jwt_group" {
  namespace = vault_namespace.parent.path
  name     = "jwt_group"
  type     = "external"
  policies = ["default", "ag_admin", "ab_admin", "gb_admin" ]

  metadata = {
    version = "2"
  }

  member_entity_ids = [vault_identity_entity.tf_user.id]
}
resource "vault_identity_group_alias" "jwt-group-alias" {
  namespace = vault_namespace.parent.path
  name           = var.identifier
  mount_accessor = vault_jwt_auth_backend.jwt.accessor
  canonical_id   = vault_identity_group.jwt_group.id
}

resource "vault_identity_entity" "jwt_user" {
  namespace = vault_namespace.parent.path
  name = var.identifier
}



resource "vault_identity_entity_alias" "jwt_user" {
    namespace = vault_namespace.parent.path
  name            = var.identifier
  mount_accessor  = vault_jwt_auth_backend.jwt.accessor
  canonical_id    = vault_identity_entity.jwt_user.id
}
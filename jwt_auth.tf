variable "identifier" {
    description = "the indentifier used for entity and group alocation"
    default = "guy@hashicorp.com"
}
# copy the public key from JWT.io and change the "\n"s as necessary
variable "jwt_validation_pubkeys" {
    description = "public key for offline jwt configuration, you can use JWT.io to generate the token and signing public keys"
    type = list(string)
    default = ["-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo\n4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u\n+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh\nkd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ\n0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg\ncKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc\nmwIDAQAB\n-----END PUBLIC KEY-----"]
}


# # in JWT.io , go to RS256 , copy the public key to the variable above ,  and create your token with the following payload:

# {
#   "sub": "1234567890",
#   "name": "Guy Barros",
#   "email": "guy@hashicorp.com",
#   "project_id":"projecta",
#   "admin": true,
#   "iat": 1516239022,
#   "exp": 1800000000
# }

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
  user_claim      = "name"
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

# resource "vault_identity_entity" "jwt_user" {
#   namespace = vault_namespace.parent.path
#   name = var.identifier
# }



# resource "vault_identity_entity_alias" "jwt_user" {
#     namespace = vault_namespace.parent.path
#   name            = var.identifier
#   mount_accessor  = vault_jwt_auth_backend.jwt.accessor
#   canonical_id    = vault_identity_entity.jwt_user.id
# }
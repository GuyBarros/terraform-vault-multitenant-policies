resource "vault_token_auth_backend_role" "test-role" {
  role_name              = "test-role"
  namespace = vault_namespace.parent.path
  allowed_policies       = ["default"]
  orphan                 = false
  token_period           = "86400"
  renewable              = true
  token_explicit_max_ttl = "115200"
  path_suffix            = "path-suffix"
  allowed_entity_aliases = ["*"]
}

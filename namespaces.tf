provider "vault" {}

variable "child_namespaces" {
  type = set(string)
  default = [
    "AB",
    "AG",
    "GB",
  ]
}

resource "vault_namespace" "parent" {
  path = "KMS"
}

resource "vault_namespace" "children" {
  for_each  = var.child_namespaces
  namespace = vault_namespace.parent.path
  path      = each.key
}

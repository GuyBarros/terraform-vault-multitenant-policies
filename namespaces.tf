provider "vault" {}

variable "child_namespaces" {
  type = set(string)
  default = [
    "child_0",
    "child_1",
    "child_2",
  ]
}

resource "vault_namespace" "parent" {
  path = "parent"
}

resource "vault_namespace" "children" {
  for_each  = var.child_namespaces
  namespace = vault_namespace.parent.path
  path      = each.key
}

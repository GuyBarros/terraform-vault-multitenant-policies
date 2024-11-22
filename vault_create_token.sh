vault token create -display-name=admin -entity-alias=tf_alias -role=test-role -namespace=admin/parent

vault token lookup token from above


vault read auth/token/lookup-self

vault token create -display-name=admin -entity-alias=tf_alias -role=test-role -namespace=admin/parent

vault token create -policy=admin-layer2-kms

vault token create -namespace=KMS -policy=admin-layer2-kms -policy=ag_admin -policy=ab_admin -policy=gb_admin


vault token create -namespace=kms -policy=admin-layer2-kms

vault token create -display-name=admin -namespace=admin/KMS -policy=vault-admin-kms -policy=default -policy=ag_admin -policy=gb_admin -policy=ag_admin -policy=vault-admin-kms
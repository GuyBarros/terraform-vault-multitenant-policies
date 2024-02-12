vault token create -display-name=admin -entity-alias=tf_alias -role=test-role -namespace=admin/parent

 vault token lookup token from above





vault token create -policy=admin-layer2-kms,vault-admin-kms -namespace=admin/kms


vault read auth/token/lookup-self



 vault write sys/capabilities-self path=secrets/vf-vci_sms_nonlive_secret


vault write sys/capabilities-self path=sys/auth/
vault token create -display-name=admin -entity-alias=tf_alias -role=test-role -namespace=admin/parent

 vault token lookup token from above


vault read auth/token/lookup-self

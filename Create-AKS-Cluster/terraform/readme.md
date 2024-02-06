AGIC ingress issue : 

to get <AGIC-IDENTITY-PRINCIPAL-ID>

az ad sp list --query "[].{displayName:displayName, appId:appId}"


az role assignment create --role Reader --scope /subscriptions/a328c5f3-dad3-4773-bf37-6005d191bd80/resourceGroups/kishore-aks --assignee <AGIC-IDENTITY-PRINCIPAL-ID>


az role assignment create --role Contributor --scope /subscriptions/a328c5f3-dad3-4773-bf37-6005d191bd80/resourceGroups/kishore-aks/providers/Microsoft.Network/applicationGateways/kishore-appgw --assignee <AGIC-IDENTITY-PRINCIPAL-ID>


kubectl delete pod -n kube-system ingress-appgw-deployment-6465f7ccdf-9wdfg



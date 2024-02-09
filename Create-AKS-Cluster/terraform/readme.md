AGIC ingress issue : 

to get <AGIC-IDENTITY-PRINCIPAL-ID>

az ad sp list --query "[].{displayName:displayName, appId:appId}"


az role assignment create --role Reader --scope /subscriptions/<SUBSCRPTION-ID>/resourceGroups/<AKS-RESOURCE-GROUP>--assignee <AGIC-IDENTITY-PRINCIPAL-ID>


az role assignment create --role Contributor --scope /subscriptions/<SUBSCRPTION-ID>/resourceGroups/kishore-aks/providers/Microsoft.Network/applicationGateways/kishore-appgw --assignee <AGIC-IDENTITY-PRINCIPAL-ID>


az role assignment create --role Contributor --scope /subscriptions/<SUBSCRPTION-ID>/resourceGroups/<AKS-MANAGED-NODE-RESOURCE-GROUP>/providers/Microsoft.Network/applicationGateways/kishore-appgw --assignee <AGIC-IDENTITY-PRINCIPAL-ID>

kubectl delete pod -n kube-system ingress-appgw-deployment-6465f7ccdf-9wdfg

## Cost Saving Options

# Stop the AGIC ingress & K8S Cluster
az aks stop --name kishore-aks-cluster --resource-group kishore-aks && 
az network application-gateway stop --name kishore-appgw --resource-group kishore-aks

# Start  the AGIC ingress & K8S Cluster
az network application-gateway start --name kishore-appgw --resource-group kishore-aks && 
az aks start --name kishore-aks-cluster --resource-group kishore-aks

# Azure Ingress - URL Routing

## Introduction
- We are going to understand and implement about `Ingress Path based/URL Routing`

## Review k8s Application Manifests
- **App1 Application Folder:** NginxApp1-Manifests
  - NginxApp1-Deployment.yml
  - NginxApp1-ClusterIP-Service.yaml
- **App2 Application Folder:** NginxApp2-Manifests
  - NginxApp2-Deployment.yml
  - NginxApp2-ClusterIP-Service.yaml
- **Myapp Application Folder (Default Backend):** MyApp-Manifests
  - myapp-Deployment.yaml
  - myapp-ClusterIP-Service.yaml

## Review Ingress Service Manifests
- [Ingress API Reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/)
- Discuss in detail about [Ingress Paths](https://kubernetes.io/docs/concepts/services-networking/ingress/#examples)
- **Ingress Manifest:** Ingress-URL-Routing.yml
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-url-routing
spec:
  ingressClassName: azure-application-gateway
  defaultBackend:
    service:
      name: myapp-nginx-clusterip-service
      port:
        number: 80
  rules:
    - http:
        paths:
          - path: /app1
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-clusterip-service
                port: 
                  number: 80
          - path: /app2
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-clusterip-service
                port: 
                  number: 80  
#          - path: /
#            pathType: Prefix
#            backend:
#              service:
#                name: myapp-nginx-clusterip-service
#                port: 
#                  number: 80                  
```

## Deploy and Verify
```t
# Deploy Apps
kubectl apply -R -f kube-manifests-defaultBackend/

# List Deployments
kubectl get deploy

# List Pods
kubectl get pods

# List Services
kubectl get svc

# List Ingress
kubectl get ingress
```

## Access Applications
```t
# Access App1 (/app1) Application
curl http://<INGRESS-IP>/app1/index.html
http://<INGRESS-IP>/app1/index.html

# Access App2 (/app2) Application
curl http://<INGRESS-IP>/app2/index.html
http://<INGRESS-IP>/app2/index.html

# Access MyApp (Root Context /) Application
curl http://<INGRESS-IP>
http://<INGRESS-IP>
```

## Verify Application Gateway Ingress Pod Logs
```t
# Verify ingress-appgw pod Logs 
kubectl -n kube-system logs -f $(kubectl -n kube-system get po | egrep -o 'ingress-appgw-deployment[A-Za-z0-9-]+')
```

## Verify Azure AKS Cluster using Azure Portal
- **Workloads:** Review workloads
- **Services and Ingresses Tab:** Review services

## Verify Application Gateway using Azure Portal
- Please review and observe all default settings in detail
- **Backend Pools Tab:** Review Backend Pools
- **Backend Settings Tab:**   
  - Review `Backend Port`
  - Review the probe `custom probe`
```t  
# Make a note of these settings
1. In AppGW -> Backend Settings for Root Context defaultBackend (bp-default-myapp-nginx-clusterip-service-80-80-ingress-url-routing) will use "defaultprobe-Http" instead of dedicated HTTP Probe
```
- **Rules Tab:** 
  - We should see default basic rule configured
  - Open default rule and review `Backend Targets` tab
- **Health probes Tab:**       
  - We should see `custom HTTP probe` created for App1 and App2 and they use their own probe
  - For `defaultBackend`, we will see `defaultprobe-HTTP` is used

## Clean-Up Applications
```t
# Delete Apps
kubectl delete -R -f kube-manifests-defaultBackend/

# Review Application Gateway Tabs
1. Backend Pools Tab 
2. Backend Settings Tab
3. Rules Tab
```

##: Update Ingress Root Context to use "path: /" instead of defaultBackend
- **Kube Manifests Folder:** kube-manifests-root-httppath
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-url-routing
spec:
  ingressClassName: azure-application-gateway
  rules:
    - http:
        paths:
          - path: /app1
            pathType: Prefix
            backend:
              service:
                name: app1-nginx-clusterip-service
                port: 
                  number: 80
          - path: /app2
            pathType: Prefix
            backend:
              service:
                name: app2-nginx-clusterip-service
                port: 
                  number: 80  
          - path: /
            pathType: Prefix
            backend:
              service:
                name: myapp-nginx-clusterip-service
                port: 
                  number: 80                  
```
## : Deploy and Verify
```t
# Deploy and Verify
kubectl apply -f kube-manifests-root-httppath/

# Review Key Difference
1. In AppGW -> Backend Settings we will see that for Root Context related setting (bp-default-myapp-nginx-clusterip-service-80-80-ingress-url-routing), dedicated HTTP probe other than  "defaultprobe-Http"

# Access App1 (/app1) Application
curl http://<INGRESS-IP>/app1/index.html
http://<INGRESS-IP>/app1/index.html

# Access App2 (/app2) Application
curl http://<INGRESS-IP>/app2/index.html
http://<INGRESS-IP>/app2/index.html

# Access MyApp (Root Context /) Application
curl http://<INGRESS-IP>
http://<INGRESS-IP>
```

## Clean-Up Applications
```t
# Delete Apps
kubectl delete -f kube-manifests-root-httppath/

# Review Application Gateway Tabs
1. Backend Pools Tab 
2. Backend Settings Tab
3. Rules Tab
```
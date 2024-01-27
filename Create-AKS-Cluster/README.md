# Create AKS Cluster

## S1: Introduction
- Create Azure AKS Cluster
- Connect to Azure AKS Cluster using Azure Cloud Shell
- Explore Azure AKS Cluster Resources
- Install Azure CLI and Connect to Azure AKS Cluster using Azure CLI on local desktop
- Deploy Sample Application on AKS Cluster and test


## S2: Create AKS Cluster
- Create Kubernetes Cluster
- **Basics**
  - **Subscription:** Kishore Azure subscription
  - **Resource Group:** Creat New: aks-rg1
  - **Cluster preset configuration:** Standard
  - **Kubernetes Cluster Name:** Kishore-AKS
  - **Region:** (US) East US
  - **Availability zones:** Zones 1, 2, 3
  - **AKS Pricing Tier:** Free
  - **Kubernetes Version:** Select what ever is latest stable version(v1.27.7)
  - **Automatic upgrade:** Enabled with patch (recommended)
  - **Node Size:** Standard DS2 v3
  - **Scale method:** Autoscale
  - **Node Count range:** 1 to 2
- **Node Pools**
  - agentpool(1-2)
  - userpool(2-3)
- **Access**
  - **Authentication and Authorization:** 	Local accounts with Kubernetes RBAC
  - Rest all leave to defaults
- **Networking**
  - **Network Configuration:** Azure CNI
  - Review all the auto-populated details 
    - Virtual Network
    - Cluster Subnet
    - Kubernetes Service address range
    - Kubernetes DNS Service IP Address
    - DNS Name prefix
  - **Traffic routing:** leave to defaults
  - **Security:** Leave to defaults
- **Integrations**
  - **Azure Container Registry:** None
  - All leave to defaults
- **Advanced**
  -  All leave to defaults
- **Tags**
  - leave to defaults
- **Review + Create**
  - Click on **Create**


## Step-03: Cloud Shell - Configure kubectl to connect to AKS Cluster
- Go to https://shell.azure.com
```t
# Template
az aks get-credentials --resource-group <Resource-Group-Name> --name <Cluster-Name>

# Replace Resource Group & Cluster Name
az aks get-credentials --resource-group aks-rg1 --name Kishore-AKS

# List Kubernetes Worker Nodes
kubectl get nodes 
kubectl get nodes -o wide
```

## S4: Explore Cluster Control Plane and Workload inside that
```t
# List Namespaces
kubectl get namespaces
kubectl get ns

# List Pods from all namespaces
kubectl get pods --all-namespaces

# List all k8s objects from Cluster Control plane
kubectl get all --all-namespaces
```

## S5: Exploring AKS cluster on Azure Management Console
- **Overview**
  - Activity Log
  - Access Control (IAM)
  - Security
  - Diagnose and solver problems
  - Microsoft Defender for Cloud
- **Kubernetes Resources**  
  - Namespaces
  - Workloads
  - Services and Ingress
  - Storage
  - Configuration
- **Settings**
  - Node Pools
  - Cluster Configuration
  - Extensions + Applications
  - Backup (preview)
  - Open Service Mesh
  - GitOps
  - Automated Deployments (preview)
  - Policies
  - Properties
  - Locks
- **Monitoring**
  - Insights
  - Alerts
  - Metrics
  - Diagnostic Settings
  - Advisor Recommendations
  - Logs
  - Workbooks
- **Automation** 
  - Tasks
  - Export Template    



## S6: Local Desktop - Install Azure CLI and Azure AKS CLI
```t
# Install Azure CLI (MAC)
brew update && brew install azure-cli

# Login to Azure
az login

# Install Azure AKS CLI
az aks install-cli

# Configure Cluster Creds (kube config)
az account set --subscription <subscription id>
az aks get-credentials --resource-group aks-rg1 --name Kishore-AKS --overwrite-existing

# List AKS Nodes
kubectl get nodes 
kubectl get nodes -o wide
```
- **Reference Documentation Links**
- https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
- https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

## S7: Deploy Sample Application and Test
```t
# Deploy Application
kubectl apply -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify Deployment
kubectl get deployment

# Verify Service (Make a note of external ip)
kubectl get service

# Access Application
http://<External-IP-from-get-service-output>
```

## S8: Clean-Up
```t
# Delete Applications
kubectl delete -f kube-manifests/
```

## References
- https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest

## Why Managed Identity when creating Cluster?
- https://docs.microsoft.com/en-us/azure/aks/use-managed-identity
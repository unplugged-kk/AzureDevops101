terraform {
  backend "azurerm" {
    resource_group_name  = "kishore-aks"
    storage_account_name = "kishoreazrsa"
    container_name       = "kishore-tf-backend"
    key                  = "kishoreazrsa-kishore-tf-backend.terraform.tfstate"
    # Use the following line if you're using an access key:
    # access_key = "<ACCESS_KEY>"
    # Use the following line if you're using a managed service identity (MSI):
    # use_msi = true
    # Use the following line if you're using a service principal:
    # tenant_id       = "<TENANT_ID>"
    # subscription_id = "<SUBSCRIPTION_ID>"
    # client_id       = "<CLIENT_ID>"
    # client_secret   = "<CLIENT_SECRET>"
  }
}

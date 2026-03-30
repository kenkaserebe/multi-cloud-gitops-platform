# /multi-cloud_gitops_platform/environments/azure/backend.tf

# This is where the Azure terraform state file will be stored.
terraform {
  backend "azurerm" {
    key                     = "aks-cluster/terraform.tfstate"
    # resource_group_name   = provided dynamically
    # storage_account_name  = provided dynamically
    # container_name        = provided dynamically
    # access_key            = provided dynamically (or use Azure AD auth)
  }
}

# When initializing, you'll provide the values:
# cd environments/azure
# terraform init \
#   -backend-config="resource_group_name=ken-terraform-state-rg" \
#   -backend-config="storage_account_name=kenmulticloudtfstate" \
#   -backend-config="container_name=tfstate" \
#   -backend-config="access_key=primary_access_key"  #"use_azuread_auth=true"     
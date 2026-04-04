# multi-cloud-gitops-platform/environments/azure/main.tf

resource "azurerm_resource_group" "this" {
  name      = var.resource_group_name
  location  = var.location
  tags      = var.tags
}

module "aks_cluster" {
  source                  = "../modules/aks"

  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  cluster_name            = var.cluster_name
  # container_name          = var.container_name
  kubernetes_version      = var.kubernetes_version
  node_count              = var.node_count
  node_vm_size            = var.node_vm_size
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  dns_prefix              = var.dns_prefix
  enable_auto_scaling     = var.enable_auto_scaling
  min_node_count          = var.min_node_count
  max_node_count          = var.max_node_count

  tags = {
    Environment           = "dev"
    ManagedBy             = "Terraform"
  }
}


# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name != "" ? var.acr_name : replace("${var.cluster_name}acr", "-", "")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = false    # Use managed identity instead
  tags                = var.tags
}


# Grant AKS managed identity AcrPull role on the ACR
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id          = module.aks_cluster.managed_identity_principal_id
  role_definition_name  = "AcrPull"
  scope                 = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value                 = azurerm_container_registry.acr.login_server
}
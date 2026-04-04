# multi-cloud-gitops-platform/environments/modules/aks/main.tf

# Virtual network
resource "azurerm_virtual_network" "this" {
  name                  = "${var.cluster_name}-vnet"
  location              = var.location
  resource_group_name   = var.resource_group_name
  address_space         = var.vnet_address_space
  tags                  = var.tags
}


# Subnet for AKS nodes
resource "azurerm_subnet" "aks" {
  name                  = "${var.cluster_name}-subnet"
  resource_group_name   = var.resource_group_name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = var.subnet_address_prefixes
}


# AKS Cluster
resource "azurerm_kubernetes_cluster" "this" {
  name                  = var.cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = var.dns_prefix != "" ? var.dns_prefix : var.cluster_name
  kubernetes_version    = var.kubernetes_version

  # Use system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                    = "default"
    node_count              = var.node_count
    vm_size                 = var.node_vm_size
    vnet_subnet_id          = azurerm_subnet.aks.id

    # Enabled auto-scaling if desired
    auto_scaling_enabled    = var.enable_auto_scaling
    min_count               = var.enable_auto_scaling ? var.min_node_count : null
    max_count               = var.enable_auto_scaling ? var.max_node_count : null
  }

  network_profile {
    network_plugin  = "kubenet"
    network_policy  = "calico"
    service_cidr    = "10.0.0.0/16"
    dns_service_ip  = "10.0.0.10"
  }

  # Enable RBAC
  role_based_access_control_enabled = true

  tags          = var.tags

  depends_on    = [
    azurerm_subnet.aks
  ]
}
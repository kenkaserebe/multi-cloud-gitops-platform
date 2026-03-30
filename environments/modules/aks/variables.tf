# multi-cloud-gitops-platform/environments/modules/aks/variables.tf

variable "location" {
  description   = "Azure region"
  type          = string
}

variable "resource_group_name" {
  description   = "Resource group name"
  type          = string
}

variable "cluster_name" {
  description   = "AKS cluster name"
  type          = string
}

variable "vnet_address_space" {
  description   = "Address space for the virtual network"
  type          = list(string)
}

variable "subnet_address_prefixes" {
  description   = "Address prefixes for the AKS subnet"
  type          = list(string)
}

variable "kubernetes_version" {
  description   = "Kubernetes version"
  type          = string
}

variable "enable_auto_scaling" {
  description   = "Enable auto-scaling for the default node pool"
  type          = bool
  default       = false
}

variable "node_count" {
  description   = "Number of worker nodes"
  type          = number
  default       = 2
}

variable "min_node_count" {
  description   = "Minimum node count when auto-scaling enabled"
  type          = number
  default       = 1
}

variable "max_node_count" {
  description   = "Maximum node count when auto-scaling enabled"
  type          = number
  default       = 3
}

variable "node_vm_size" {
  description   = "VM size for worker nodes"
  type          = string
  default       = "standard_b2s_v2" 
}

variable "dns_prefix" {
  description   = "DNS prefix for the cluster (if empty, uses cluster name)"
  type          = string
  default       = ""
}


variable "tags" {
  description   = "Tags to apply to resources"
  type          = map(string)
  default       = {}
}
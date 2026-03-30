# multi-cloud-gitops-platform/environments/aws/main.tf


module "eks_cluster" {
  source = "../modules/eks"

  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  node_instance_type = var.node_instance_type
  desired_node_count = var.desired_node_count
  min_node_count     = var.min_node_count
  max_node_count     = var.max_node_count

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


# ECR repository for the application
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.cluster_name}-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


# Data sources to get authentication info for the EKS cluster
data "aws_eks_cluster" "this" {
  name       = module.eks_cluster.cluster_name
  depends_on = [module.eks_cluster] # ensure cluster is created
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_cluster.cluster_name
}


# Configure Kubernetes provider to use the EKS cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint #aws_eks_cluster.this.endpoint #
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}










# Output ecr repository url
output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}


# Add the EBS CSI Driver Add-on
# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name = module.eks_cluster.cluster_name
#   addon_name   = "aws-ebs-csi-driver"
#   depends_on   = [module.eks_cluster] # Ensure cluster exists first
# }
# multi-cloud-gitops-platform/environments/aws/backend.tf

terraform {
  backend "s3" {
    key = "eks-cluster/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true  # Enables s3 native locking (Terraform 1.11+)
    # bucket = This is provided by you via -backend-config or file
  }
}


# When initializing the main AWS environment, you'll run:
# cd environment/aws
# terraform init -backend-config="bucket=<the-name-of-the-bucket>"

# OR

# Create a file backend.hcl with:
# 'bucket = "<the-name-of-the-bucket>"'
# And then use terraform init -backend-config=backend.hcl.
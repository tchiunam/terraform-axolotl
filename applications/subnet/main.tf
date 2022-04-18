# data "aws_availability_zones" "azs" {
#   state = "available"
# }

data "terraform_remote_state" "axolotl_vpc" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket  = "axolotl-terraform-state"
    key     = "vpc"
    region  = "ap-east-1"
    encrypt = true
  }
}

module "axolotl_subnet" {
  source = "../../modules/subnet"

  availability_zones         = ["ap-east-1a", "ap-east-1b"]
  private_subnets_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets_cidr_block  = ["10.0.101.0/24", "10.0.102.0/24"]

  project = "axolotl"
  name    = "main"
  vpc_id  = data.terraform_remote_state.axolotl_vpc.outputs.vpc_id

  env_shortname_map = var.env_shortname_map
}

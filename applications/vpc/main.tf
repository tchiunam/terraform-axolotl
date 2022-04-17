module "axolotl_vpc" {
  source = "../../modules/vpc"

  name    = "axolotl"
  project = "axolotl"
}

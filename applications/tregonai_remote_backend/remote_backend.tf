terraform {
  backend "s3" {
    bucket         = "axolotl-terraform-state"
    key            = "axolotl_remote_backend"
    region         = "ap-east-1"
    dynamodb_table = "axolotl-terraform-state-locking"
    encrypt        = true
  }
}

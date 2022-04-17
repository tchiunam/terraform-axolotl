terraform {
  backend "s3" {
    bucket         = "axolotl-terraform-state"
    key            = "vpc"
    region         = "ap-east-1"
    dynamodb_table = "axolotl-terraform-state-locking"
    encrypt        = true
  }
}

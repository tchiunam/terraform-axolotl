variable "project" {
  type        = string
  description = "Project name which the resources belong to."
}

variable "name" {
  type        = string
  description = "VPC name."

}

variable "instance_tenancy" {
  type        = string
  description = "Instance tenancy."

  default = "default"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC."

  default = "10.0.0.0/16"
}

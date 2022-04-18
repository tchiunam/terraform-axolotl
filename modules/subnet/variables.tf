variable "env_shortname_map" {
  type        = map(string)
  description = "Mapping from environment long name to short name."
}

variable "project" {
  type        = string
  description = "Project name which the resources belong to."
}

variable "name" {
  type        = string
  description = "Subnet name."

}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which subnet is created in."
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones where public/private subnets are in."
}

variable "private_subnets_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets."

  default = ["10.0.1.0/24"]
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets."

  default = ["10.0.101.0/24"]
}

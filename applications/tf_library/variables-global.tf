variable "aws_region" {
  type        = string
  description = "AWS region in which resources are deployed to."
}

variable "env_shortname_map" {
  type        = map(string)
  description = "Mapping from environment long name to short name."
}

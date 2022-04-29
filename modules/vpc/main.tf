resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name        = var.name
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "default" {
  name        = "asg-vpc-default"
  description = "Default Security Group for VPC."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "ingress_allow_tcp" {
  security_group_id = aws_security_group.default.id
  description       = "Allow TCP incoming traffic from any ports."
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "egress_allow_all" {
  security_group_id = aws_security_group.default.id
  description       = "Allow all types of outgoing traffic through any ports."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-${var.name}-igw"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-${var.name}-nat"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  count                   = length(var.private_subnets_cidr_block)
  cidr_block              = element(var.private_subnets_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-private_subnet-${var.name}-${count.index}-${element(var.availability_zones, count.index)}"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  count                   = length(var.public_subnets_cidr_block)
  cidr_block              = element(var.public_subnets_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-public_subnet-${var.name}-${count.index}-${element(var.availability_zones, count.index)}"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-private-route_table"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${lookup(var.env_shortname_map, terraform.workspace)}-${var.project}-public-route_table"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr_block)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr_block)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  # 3 AZs
  count = 3
  vpc   = true
  tags = merge(local.default_tags, {
    "Name" = "infra-nat01"
  })
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3)
  # This creates:
  #  - 3x /19 for private_subnets
  #  - 3x /22 for private_subnets
  #  - 3x /22 for private_subnets
  subnets          = cidrsubnets(var.vpc_cidr, 3, 3, 3, 6, 6, 6, 6, 6, 6)
  private_subnets  = slice(local.subnets, 0, 3)
  database_subnets = slice(local.subnets, 3, 6)
  public_subnets   = slice(local.subnets, 6, 9)
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "v3.14.2"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  enable_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = true
  reuse_nat_ips          = true
  azs                    = local.availability_zones
  external_nat_ip_ids    = aws_eip.nat[*].id
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets
  database_subnets       = local.database_subnets
  tags                   = local.default_tags
  # public_subnet_tags     = local.public_subnet_tags
  # private_subnet_tags    = local.private_subnet_tags
  # database_subnet_tags   = local.database_subnet_tags
}

resource "aws_route53_zone" "local" {
  name = "local.vpc"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  tags = local.default_tags
}

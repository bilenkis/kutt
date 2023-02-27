module "cache" {
  source                  = "../../../../modules/elasticache"
  name                    = "kutt"
  subnet_ids              = module.vpc.private_subnets
  vpc_id                  = module.vpc.vpc_id
  allowed_security_groups = [module.eks_eu01_infra01.node_security_group_id]
  node_type               = "cache.t4g.small"
  number_cache_clusters   = 1
  route53_zone_id         = aws_route53_zone.local.zone_id
  # cloudwatch_create_alarms = true
  engine_version         = "6.x"
  parameter_group_family = "redis6.x"
}

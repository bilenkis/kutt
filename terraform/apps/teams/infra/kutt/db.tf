resource "random_password" "master" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
}

module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v4.13.0"

  name        = "kutt-db-sg"
  description = "Security group for kutt Aurora RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = "5432"
      to_port                  = "5432"
      protocol                 = "tcp"
      description              = "Allow EKS cluster nodes"
      source_security_group_id = module.eks_eu01_infra01.node_security_group_id
    },
  ]
  tags = local.default_tags
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.3"

  identifier            = local.db_name
  engine                = "postgres"
  engine_version        = "14.3"
  family                = "postgres14"
  major_engine_version  = "14"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 10
  max_allocated_storage = 100
  storage_encrypted     = true
  kms_key_id            = "arn:aws:kms:eu-west-1:1111111111111:key/a3d17fd9-83bd-4bad-89b0-6b4b40fe8ba9"


  db_name  = "kutt"
  username = "kutt"
  password = random_password.master.result
  port     = 5432

  vpc_security_group_ids = [module.db_sg.security_group_id]

  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets

  create_db_parameter_group = true
  parameter_group_name      = aws_db_parameter_group.db.id

  final_snapshot_identifier_prefix = "final-snapshot"
  auto_minor_version_upgrade       = false
  apply_immediately                = true
}

resource "aws_db_parameter_group" "db" {
  name        = "kutt-postgresql14-parameter-group"
  family      = "aurora-postgresql14"
  description = "kutt-postgresql14-parameter-group"
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name_prefix = "kutt-db-credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username            = module.db.db_instance_username,
    password            = module.db.db_instance_password,
    host                = module.db.db_instance_address,
    port                = module.db.db_instance_port,
    dbClusterIdentifier = module.db.db_instance_id,
  })
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.local.zone_id
  name    = "kutt.rds"
  type    = "CNAME"
  ttl     = 60
  records = [module.db.db_instance_address]
}

output "db_credentials" {
  value = "aws --profile ${var.aws_profile} --region ${var.aws_region} secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.rds_credentials.name} --no-cli-pager"
}

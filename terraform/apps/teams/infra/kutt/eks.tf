module "eks_eu01_infra01" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "18.29.0"
  cluster_version                      = var.cluster_version
  cluster_name                         = var.cluster_name
  cluster_enabled_log_types            = []
  subnet_ids                           = module.vpc.private_subnets
  vpc_id                               = module.vpc.vpc_id
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.my_ip]

  # manage_aws_auth_configmap = true
  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::1111111111111:user/bilen"
  #     username = "admin:{{SessionName}}"
  #     groups   = ["system:masters"]
  #   },
  # ]

  node_security_group_additional_rules = {
    egress_all = {
      description      = "Allow nodes to communicate with the outside world"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_cluster_to_node_all_traffic = {
      description                   = "allow all traffic from control plane to nodes"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    ami_id                     = data.aws_ami.eks_default.image_id
    enable_bootstrap_user_data = true
    pre_bootstrap_user_data    = local.userdata
    capacity_type              = "ON_DEMAND"
    # capacity_type = "SPOT"
    disk_size = 10
    # vpc_security_group_ids     = [<bastion-sg>]
    use_name_prefix          = false
    iam_role_use_name_prefix = false
  }

  eks_managed_node_groups = {
    kutt = {
      name = "${var.cluster_name}-on-demand-kutt01"

      max_size       = 4
      min_size       = 2
      desired_size   = 2
      instance_types = ["t3.small"]

      labels = {
        app        = "kutt"
        env        = "staging"
        team       = "infra"
        node_group = "kutt"
      }

      # taints = {
      #   kutt = {
      #     key    = "app"
      #     value  = "kutt"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
    }
  }

  tags = local.default_tags
}

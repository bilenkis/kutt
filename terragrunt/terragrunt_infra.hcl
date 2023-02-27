locals {
  team                = "infra"
  terraform_directory = "${get_terragrunt_dir()}/../../../../../terraform"
  tfvars_directory    = "${local.terraform_directory}/tfvars"
  app_directory       = "${local.terraform_directory}//apps/teams/${local.team}/${local.app}"
  aws_account         = element(split("/", get_terragrunt_dir()), length(split("/", get_terragrunt_dir())) - 4)
  region              = element(split("/", get_terragrunt_dir()), length(split("/", get_terragrunt_dir())) - 3)
  environment         = element(split("/", get_terragrunt_dir()), length(split("/", get_terragrunt_dir())) - 2)
  app                 = element(split("/", get_terragrunt_dir()), length(split("/", get_terragrunt_dir())) - 1)
}

terraform {
  source = "${local.app_directory}"

  extra_arguments "include_tfvars" {
    commands = [
      "plan",
      "apply",
      "destroy"
    ]

    arguments = [
      "-input=false"
    ]

    required_var_files = [
      "${local.tfvars_directory}/global.tfvars",
      "${local.tfvars_directory}/accounts/${local.aws_account}.tfvars",
      "${local.tfvars_directory}/regions/${local.region}.tfvars",
      "${local.tfvars_directory}/envs/${local.environment}.tfvars",
      "${local.app_directory}/tfvars/${local.region}-${local.environment}.tfvars",
    ]
  }
}

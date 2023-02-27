remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket     = "tf-states-bilenkis-staging"
    key        = "apps/${path_relative_to_include()}/terraform.tfstate"
    region     = "eu-west-1"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-1:1111111111111:key/a3d17fd9-83bd-4bad-89b0-6b4b40fe8ba9"
    profile    = "bilenkis-staging"
  }
}

include "terraform_config" {
  path = find_in_parent_folders("terragrunt_infra.hcl")
}

include "remote_state" {
  path = find_in_parent_folders("remote_state.hcl")
}

include "global_settings" {
  path = find_in_parent_folders("terragrunt_global.hcl")
}

locals {
  default_tags = merge(var.global_tags["default"], {
    "application"        = "kutt"
    "environment"        = var.environment
    "managedByTerraform" = "true"
    "team"               = var.team
    "region"             = var.aws_region
  })

  userdata = join(
    "\n",
    [
      <<-EOT
        # Add sudo group if it does not exist
        getent group sudo > /dev/null || groupadd sudo
        
        # Allow sudo group to become root without password
        echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-tf-ssh-users-sudo

        # configure sysctl
        sysctl fs.inotify.max_user_watches=1048576
        sysctl -p
        # configure bootstrap.sh
        export CONTAINER_RUNTIME="containerd"
      EOT
      , data.template_file.ssh_users[0].rendered
    ]
  )
  db_name = "infra-kutt01"
}

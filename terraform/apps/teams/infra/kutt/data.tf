data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "eks_default" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  filter {
    name   = "image-id"
    values = ["ami-0aa2b9f7c97126b35"]
  }

  most_recent = true
  owners      = ["amazon"]
}

data "template_file" "ssh_users" {
  count = length(var.ssh_users)

  template = <<EOF

echo "#### Creating user $${username}"
useradd $${username} --create-home --shell /bin/bash
mkdir ~$${username}/.ssh
echo "$${key}" > ~$${username}/.ssh/authorized_keys
chown -R $${username}: ~$${username}/.ssh
chmod 0600 ~$${username}/.ssh/authorized_keys
usermod -a -G sudo $${username}
EOF


  vars = {
    username = var.ssh_users[count.index]["username"]
    key      = var.ssh_users[count.index]["key"]
  }
}

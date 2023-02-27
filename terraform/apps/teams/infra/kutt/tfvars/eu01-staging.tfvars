vpc_name        = "infra01"
cluster_name    = "infra01"
cluster_version = "1.22"
vpc_cidr        = "10.40.0.0/16"
my_ip           = "89.247.166.216/32"

ssh_users = [
  {
    username = "bilenkis",
    key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDimgco9BPbo89Erj02xKQooPpcwfjvnANnnkgRhI3+iReA/XW6rAk1L4ba8dlTLGphjdHI7AVommleEFSDdgT6Hyo177fVqTIWz+6fFNLhcZrFWCoEMQd8pZ20PZaO4z6yEriTkpueMZ3GVvTkkdmBO0KKyjL3B9F02sYhxGSN3xfW86sJcLaHL/NVBcZ8xjvpXUj+LTcqoLdw3rbc3izoM89/l/HwDdMFPKso2k2L1/8A5ZX6Qa3oPY4Ufwofbli5YdGEfwKHLyIk2J9VDtVojjC7BIWGO/0kf5PdS8Bc53ldaeLWFdDBwSa3VI1Bs12mIusoocL0s/MOEM0ewDr7"
  },
]

variable "environment" {
  type = string
}

variable "team" {
  type    = string
  default = "infra"
}

variable "aws_region" {
  type = string
}

variable "global_tags" {
  type    = any
  default = {}
}

variable "vpc_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_allowed_account_id" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "ssh_users" {
  type = list(object(
    {
      username = string
      key      = string
    }
  ))
}

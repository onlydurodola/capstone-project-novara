variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "taskapp.xpresskode.site"
}

variable "domain_name" {
  default = "xpresskode.site"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

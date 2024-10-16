variable "aws_region" {
  default     = "us-west-2"
  type        = string
  description = "Região da AWS"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "__VPC_CIDR__"
}

variable "peer_vpc_cidr" {
  description = "CIDR block of the peer VPC"
  default     = "__ANSIBLE_VPC_CIDR__"
}

variable "ansible_vpc_id" {
  description = "VPC ID of the Ansible VPC"
  default     = "__ANSIBLE_VPC_ID__"
}

variable "ansible_vpc_region" {
  description = "Region of the Ansible VPC"
  default     = "__ANSIBLE_VPC_REGION__"
}

variable "ansible_route_table_id" {
  description = "Route Table of the Ansible VPC"
  default     = "__ANSIBLE_ROUTE_TABLE_ID__"
}

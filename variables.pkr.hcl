variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "source_ami" {
  type    = string
  default = "ami-04b70fa74e45c3917" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
}
variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "subnet_id" {
  type    = string
  default = "subnet-0ae4dd4c6b2e5a38d"
}

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

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


# https://www.packer.io/plugins/builders/amazon/ebs
source "amazon-ebs" "my-ami" {
  region          = "us-east-1"
  ami_name        = "csye7125_${formatdate("YYYY_MM_DD_hh_mm_ss", timestamp())}"
  ami_description = "AMI for Jenkins CSYE 7125"
  ami_regions = [
    "us-east-1",
  ]


  associate_public_ip_address = true
  instance_type               = "t2.micro"
  source_ami                  = "${var.source_ami}"
  subnet_id                   = "${var.subnet_id}"


  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/xvda"
    volume_size           = 8
    volume_type           = "gp2"
  }

  ssh_username = "${var.ssh_username}"

}
build {
  sources = ["source.amazon-ebs.my-ami"]



provisioner "file" {
    source = "./caddyconfig/Caddyfile"
    destination = "/tmp/Caddyfile"
  }

provisioner "file" {
    source = "./caddyconfig/caddy.service"
    destination = "/tmp/caddy.service"
  }


provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "CHECKPOINT_DISABLE=1"
    ]
    script       = "./install-jenkins.sh"
    pause_before = "5s"
  }


}

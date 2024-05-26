
# https://www.packer.io/plugins/builders/amazon/ebs
source "amazon-ebs" "my-ami" {
  region          = "us-east-1"
  ami_name        = "csye7125_${formatdate("YYYY_MM_DD_hh_mm_ss", timestamp())}"
  ami_description = "AMI for CSYE 6225"
  ami_regions = [
    "us-east-1",
  ]

  // ssh_handshake_attempts = 200
  // security_group_id      = "sg-0044673801fbe3579"
  // ssh_keypair_name       = "ec2ssh"
  // ssh_private_key_file   = "/home/mahesh/.ssh/packer-ssh.pem"

  // aws_polling {
  //   delay_seconds = 120
  //   max_attempts  = 50
  // }

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


  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "CHECKPOINT_DISABLE=1"
    ]
    script       = "./install-jenkins.sh"
    pause_before = "5s"
  }


}

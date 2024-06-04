# PACKER BUILD

###   Prerequisites for building and deploying:

- Packer
- Git bash
- Caddy
- Java
- Jenkins


## Packer file

The ami-jenkins.pkr.hcl configuration specifically sets up an Amazon Machine Image (AMI) on AWS.

### Variables:
- **aws_region**: Specifies the AWS region to use. Default is "us-east-1".
- **source_ami**: The ID of the base AMI to use for creating the new image. Default is "ami-04b70fa74e45c3917" (Ubuntu Server 24.04 LTS).
- **ssh_username**: The username to use for SSH connections. Default is "ubuntu".
- **subnet_id**: The ID of the default VPC subnet.

### Packer Configuration:
- **required_plugins**: Specifies the Packer plugins required. In this case, the Amazon plugin from HashiCorp.
  
### Source Configuration (`amazon-ebs`):
- **region**: The AWS region to create the AMI in.
- **ami_name**: The name of the new AMI, which includes a timestamp.
- **ami_description**: A description for the new AMI.
- **ami_regions**: List of regions where the AMI will be available. Here, it's only "us-east-1".
- **associate_public_ip_address**: Assigns a public IP address to the instance.
- **instance_type**: The type of instance to use, "t2.micro" in this case.
- **source_ami**: The base AMI ID, taken from the variable `source_ami`.
- **subnet_id**: The subnet ID, taken from the variable `subnet_id`.
- **launch_block_device_mappings**: Configuration for the block device. This specifies the device name, volume size (8GB), and type (gp2), and ensures the volume is deleted upon termination.
- **ssh_username**: The SSH username, taken from the variable `ssh_username`.

### Build Section:
- **sources**: Specifies the source to use for the build. Here, it's the `amazon-ebs` source defined above.
- **provisioner "shell"**: Runs a shell script (`install-jenkins.sh`) on the instance. It sets environment variables (`DEBIAN_FRONTEND=noninteractive` and `CHECKPOINT_DISABLE=1`) and pauses for 5 seconds before execution.
- **provisioner "file"**: Uploads a file (`Caddyfile`) from the local machine to the instance at `/etc/caddy/Caddyfile`.

## Shell script

The install-jenkins.sh script performs the following steps:

### Install Java:

1. Update and upgrade the package list
2. Install Java Runtime Environment (OpenJDK 17)
3. Add Jenkins repository key
4. Add Jenkins repository
5. Update package list and install Jenkins
6. Enable Jenkins to start on boot
7. Install dependencies and tools
8. Add Caddy repository key
9. Add Caddy repository
10. Update package list and install Caddy
11. Enable Caddy to start on boot


## Git Workflow

### pull workflow automates the validation of a Packer template by:

- Triggering on pull requests to the main branch or manual execution.
- Checking out the repository.
- Installing Packer.
- Initializing the Packer configuration.
- Validating the Packer template.
- This ensures that any changes to the Packer template are checked for correctness before they are merged into the main branch.


### push workflow automates the process of building an AMI with Packer by:

- Triggering on pushes to the main branch or manual execution.
- Checking out the repository.
- Installing Packer.
- Setting AWS credentials.
- Initializing and running the Packer build process

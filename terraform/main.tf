# GOAL: create a script to initialise terraform to download dependencies required for AWS

# 1. Create a script to launch ec2

# first step to create block of code to communicate with aws
provider "aws" {
    region = var.aws_region
}

# let terraform know which service/resource we want to create
resource "aws_vpc" "terraform_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
      "Name" = "${var.name}_terraform_vpc"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "${var.name}_terraform_igw"
  }
}

resource "aws_subnet" "terraform_subnet" {
    vpc_id = aws_vpc.terraform_vpc.id
    # cidr_block = var.public_subnet_cidr  
    cidr_block = var.vpc_cidr
    depends_on = [aws_internet_gateway.gw]

    tags = {
      "Name" = "${var.name}_terraform_subnet"
    }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.route_1
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}_terraform_route_table"
  }
}

resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.terraform_subnet.id
    route_table_id = aws_route_table.rt.id
}

# resource "aws_network_acl" "nacl" {
#   vpc_id = aws_vpc.terraform_vpc.id
# }

# resource "aws_network_acl_association" "sn_nacl" {
#   network_acl_id = aws_network_acl.nacl.id
#   subnet_id      = aws_subnet.terraform_subnet.id
# }

resource "aws_security_group" "terraform_sg" {
    vpc_id = aws_vpc.terraform_vpc.id

    egress = var.sg_outbound_rules
        
    ingress = var.sg_inbound_rules

    tags = {
      "Name" = "${var.name}_terraform_sg"
    }
}

resource "aws_instance" "app_instance" {

    subnet_id = aws_subnet.terraform_subnet.id
    # depends_on = [aws_internet_gateway.gw]

    # choose an AMI to create ec2
    ami = var.node_ami_id

    # what type of instance to launch
    instance_type = var.aws_instance_type

    # do we want to have it globally available - public ip
    associate_public_ip_address = true

    security_groups = ["${aws_security_group.terraform_sg.id}"]

    # name your instance 
    tags = {
        Name = "${var.name}-terraform-app"
    }

    # attach the file.pem for access from localhost
    key_name = var.aws_key_name

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.aws_key_path)
      timeout     = "2m"
   }
   provisioner "file" {
     source      = var.app_source_path
     destination = var.app_dest_path
  }
}

# # 2. Move the app folder to the instance

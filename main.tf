terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  name                = "pritunl"
  environment         = "dev"
  region              = "eu-central-1"
  ami                 = "ami-0a5b5c0ea66ec560d"
  instance_type       = "t2.micro"
  vpc_id              = "vpc-0d8d5538112eedd18"
  cidrs               = ["172.31.0.0/16"]
  subnet_id           = "subnet-040da219a6ce27dd5"
  whitelist           = ["0.0.0.0/0"]
  key_name            = "mykey"
  key_path            = "/home/daghan/.aws/pems/mykey.pem"
}

output "pritunl_private_ip" {
  value = aws_instance.main.private_ip
}

output "pritunl_public_ip" {
  value = aws_instance.main.public_ip
}
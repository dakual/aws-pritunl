resource "aws_instance" "main" {
  ami                         = local.ami
  instance_type               = local.instance_type
  key_name                    = local.key_name
  subnet_id                   = local.subnet_id
  user_data                   = file("${path.module}/provision.sh")
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.pritunl.id,
    # aws_security_group.office.id,
  ]

  # connection {
  #   type        = "ssh"
  #   user        = "admin"
  #   private_key = file(local.key_path)
  #   host        = self.public_ip
  # }

  # provisioner "file" {
  #   source      = "./install.sh"
  #   destination = "/home/admin/install.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x install.sh && sh install.sh"
  #   ]
  # }
}


resource "aws_security_group" "pritunl" {
  name        = "${local.name}-sg"
  description = "Pritunl SG"
  vpc_id      = local.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.whitelist
  }

  # HTTP access for Let's Encrypt validation
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.whitelist
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.whitelist
  }

  # VPN WAN access
  ingress {
    from_port   = 10000
    to_port     = 19999
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ICMP
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = local.whitelist
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "office" {
#   name        = "${local.name}-office-sg"
#   description = "Allows SSH connections and HTTP(s) connections from office"
#   vpc_id      = local.vpc_id

#   # SSH access
#   ingress {
#     description = "Allow SSH access from select CIDRs"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = local.whitelist
#   }

#   # HTTPS access
#   ingress {
#     description = "Allow HTTPS access from select CIDRs"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = local.whitelist
#   }

#   # ICMP
#   ingress {
#     description = "Allow ICMPv4 from select CIDRs"
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = local.whitelist
#   }

#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
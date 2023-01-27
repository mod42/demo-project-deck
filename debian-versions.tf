locals {
  render_variables = {
    DB_USER        = replace(format("%s_%s", var.service, var.environment), "-", "_")
    CE_PKG         = var.ce_pkg
    EE_PKG         = var.ee_pkg
    PARAMETER_PATH = format("/%s/%s", var.service, var.environment)
    REGION         = data.aws_region.current.name
    DECK_VERSION   = var.deck_version
    MANAGER_HOST   = var.manager_host
    PORTAL_HOST    = var.portal_host
    SESSION_SECRET = random_string.session_secret.result
    PGPASSWORD = var.pgpassword
    DB_HOST = var.db_host
    DB_NAME = var.db_name
    DB_PASSWORD = var.db_password
  }
}

# Create EC2 Instance
resource "aws_instance" "linux-server" {
  ami                         = data.aws_ami.debian-11.id
  instance_type               = var.linux_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-linux-sg.id]
  associate_public_ip_address = var.linux_associate_public_ip_address
  source_dest_check           = false 
  key_name                    = aws_key_pair.key_pair.key_name
  #user_data                   = file("cloud-init.sh")
  user_data                   = templatefile("cloud-init.sh", local.render_variables)

  
  # root disk
  root_block_device {
    volume_size           = var.linux_root_volume_size
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.linux_data_volume_size
    volume_type           = var.linux_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }
  
  tags = {
    Name = "linux-vm"
  }
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "linux-eip" {
  vpc  = true
  tags = {
    Name = "linux-eip"
  }
}
# Associate Elastic IP to Linux Server
resource "aws_eip_association" "linux-eip-association" {
  instance_id   = aws_instance.linux-server.id
  allocation_id = aws_eip.linux-eip.id
}

resource "random_string" "session_secret" {
  length  = 32
  special = false
}
resource "aws_security_group" "bastion_host_sg" {
  name        = "bastionhost_ssh_access"
  description = "allow inbound ssh traffic"
  vpc_id      = aws_vpc.main.id

  # allow ssh from public
  ingress {
    description = "ssh access from public "
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "bastion_host_ssh_access_sg"
  }
}

resource "aws_instance" "bastion_host" {
  instance_type          = var.instance_type
  ami                    = var.ami
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  subnet_id              = aws_subnet.public_subnet.id

  key_name = aws_key_pair.bastion_host_pubkey.key_name

  associate_public_ip_address = true
  tags = {
   Name = "bastion_host"
  }
}
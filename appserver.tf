resource "aws_security_group" "http-sg" {
  name        = "app_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.main.id

  # only allow http access from alb dns
  ingress {
    description = "http from alb"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # only allow ssh from bastion host
  ingress {
    description = "SSH from Bastion Host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }

  tags = {
    "Name" = "app_server_http_sg"
  }
}

resource "aws_instance" "app_server" {
  count                  = length(var.subnet_cidr_private)
  instance_type          = var.instance_type
  ami                    = var.ami
  vpc_security_group_ids = [aws_security_group.http-sg.id]
  subnet_id              = element(aws_subnet.private_subnet.*.id, count.index)
  key_name               = aws_key_pair.app_server_pubkey.key_name

  associate_public_ip_address = true
  tags = {
    Name = "app_server_${count.index + 1}"
  }
  
  # export aws credentials to be used in setup.sh
  user_data = base64encode(templatefile("./user_data/setup.sh", {
        aws_access_key  = "${var.access_key}"
        aws_secret_key = "${var.secret_key}"
      } ))
  user_data_replace_on_change = true
}
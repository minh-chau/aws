# ssh key pair to access bastion host
resource "aws_key_pair" "bastion_host_pubkey" {
  key_name   = "bastion_host_pubkey"
  public_key = file("${var.bh_ssh_pub_key}")
}
# ssh key pair to access app_server
resource "aws_key_pair" "app_server_pubkey" {
  key_name   = "app_server_pubkey"
  public_key = file("${var.app_server_ssh_pub_key}")
}


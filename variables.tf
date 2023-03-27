#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "ap-southeast-2"
}

#Define IAM User Access Key
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}

#Define IAM User Secret Key
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ami" {
  description = "ami ec2 instance"
  type        = string
  default     = "ami-047dcdc46ac4f2e6b"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_cidr_private" {
  description = "cidr blocks for the private subnets"
  default     = ["10.0.16.0/20", "10.0.32.0/20"]
  type        = list(any)
}

variable "subnet_cidr_public" {
  description = "cidr blocks for the public subnets"
  default     = "10.0.0.0/24"
  type        = string
}

variable "availability_zone" {
  description = "availability zones for the private subnets"
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
  type        = list(any)
}

variable "bh_ssh_pub_key" {
  description = "public key in key pairs to ssh to bastion host"
  type        = string
  default     = "./sshkeys/bh.pub"
}

variable "app_server_ssh_pub_key" {
  description = "public key in key pairs to ssh to app_server host"
  type        = string
  default     = "./sshkeys/app_server.pub"
}
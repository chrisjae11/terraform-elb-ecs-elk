variable "region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "vpc_id" {}
variable "subnet_ext_id" {}
variable "subnet_int_id" {}
variable "ssh_key_name" {}
variable "kibana_url" {}
variable "elk_sg" {
  description = "existing ELK security group id"
}
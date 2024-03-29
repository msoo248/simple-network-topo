variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "eu-central-1"
}

variable "availability_zone" {
  type        = string
  default     = "eu-central-1a"
  
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_cidr_block" {
  type        = list
  description = "CIDR Block for Subnets in VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_subnet_pc_cidr_block" {
  type        = list
  description = "CIDR Block for Subnets in VPC"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "MariaSoft"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}

variable "machine_name" {
  type        = string
  description = "Name of the machine"
}

variable "key_name" {
  type        = string
  default     = "ansible"
  description = ".ppk/.pem key name"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in VPC"
  default     = 2
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create in VPC"
  default     = 2
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "MarSoft"
}

variable "aws_access_key"{
  type        = string
  description = "Access key to AWS"
  sensitive   = true
}

variable "aws_secret_key"{
  type        = string
  description = "Secret key to AWS"
  sensitive   = true
}

variable "ip_list" {
  type        = list(string)
  description = "A list of ips for Quagga 0&1 to connect to quagga2"
  default = [ "10.0.1.10", "10.0.2.10" ]
}

variable "ip_list_pc" {
  type        = list(string)
  default = [ "10.0.3.10", "10.0.4.10" ]
}

variable "ip_list_for_pcs" {
  type        = list(string)
  default = [ "10.0.3.20", "10.0.4.20" ]
}

variable "quagga_hostname"{
  type        = list(string)
  default = [ "Quagga0", "Quagga1" ]
}

variable "pc_hostname"{
  type        = list(string)
  default = [ "PC0", "PC1" ]
}
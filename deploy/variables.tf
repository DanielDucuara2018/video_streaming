#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "eu-west-2"
}

variable "endpoint_api" {
  description = "The outscale endpoint in region"
  default     = "api.eu-west-2.outscale.com"
  type        = string
}

# Define IAM User Access Key
variable "access_key_id" {
  description = "The access_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}

# Define IAM User Secret Key
variable "secret_key_id" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
  sensitive   = true
  default     = ""
}

# Define EC2 instance type
variable "instance_type" {
  description = "The instance type of the EC2 instances"
  default     = "t2.large"
  type        = string
}

# Define SSH key name
variable "keypair_name" {
  description = "name of the keypair"
  default     = "outscale_main_keypair_eu"
  type        = string
}

# Define AMI id for EC2 instances
variable "omi_id" {
  description = "The id of RockyLinux-9-2023.11.17-0 2024-01-04"
  default     = "ami-0baeccc5"
  type        = string
}

# ip range for main vpc
variable "vpc_ip_range" {
  description = "The cidr of the vpc"
  default     = "192.168.0.0/16"
  type        = string
}


variable "subnet_ip_range_public" {
  description = "cidr blocks for the public subnets"
  default     = "192.168.1.0/24"
  type        = string
}

variable "subnet_ip_range_private" {
  description = "cidr blocks for the private subnets"
  default     = "192.168.2.0/24"
  type        = string
}

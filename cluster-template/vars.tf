variable "awsregion" {
  default = "eu-central-1"
}
variable "environment" {
  default = "dev"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default = "10.4.0.0/22"
}

variable "subnets_public" {
  description = "CIDR block for the public subnet"
  default = ["10.4.0.0/26","10.4.0.64/26","10.4.0.128/26",]
}

variable "subnets" {
  default = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24"]
}

variable "image_id" {
  default = "ami-09e7549e8fc2233b9"
}
variable "instance_type" {
  default = "t2.small"
}

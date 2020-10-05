module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  name = var.environment

  cidr = var.vpc_cidr

  azs = ["${var.awsregion}a", "${var.awsregion}b", "${var.awsregion}c"]

  public_subnets  = var.subnets_public
  private_subnets = var.subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_ipv6 = false

  enable_dns_hostnames = true
  enable_dns_support   = true

}

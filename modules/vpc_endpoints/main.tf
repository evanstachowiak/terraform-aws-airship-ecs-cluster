module vpc_endpoints {
  # TODO
  # Use original source once this pull request has been merged:
  # https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/pull/14
  //  source = "plus3it/terraform-aws-tardigrade-vpc-endpoints"
  //  source = "github.com/evanstachowiak/terraform-aws-tardigrade-vpc-endpoints"
  source = "../../../terraform-aws-tardigrade-vpc-endpoints"

  create_sg_per_endpoint = var.create && var.create_sg_per_endpoint
  create_vpc_endpoints   = var.create
  sg_egress_rules        = var.sg_egress_rules
  sg_ingress_rules       = var.sg_ingress_rules
  subnet_ids             = var.subnet_ids
  tags = {
    env = terraform.workspace
  }
  vpc_endpoint_services = local.vpc_endpoint_services
}


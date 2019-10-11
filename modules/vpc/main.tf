resource "aws_security_group_rule" "ecs_cluster_instances_egress_to_vpn_endpoints" {
  count = var.create ? length(module.vpc_endpoints.vpc_endpoint_sgs) : 0

  description       = "egress from ecs cluster instance to ecs vpn endpoints"
  security_group_id = var.asg_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443

  source_security_group_id = module.vpc_endpoints.vpc_endpoint_sgs[count.index].id
}

resource "aws_security_group_rule" "ecs_vpn_endpoints_ingress_from_ecs_instances" {
  count = var.create ? length(module.vpc_endpoints.vpc_endpoint_sgs) : 0

  description       = "ingress from ecs cluster instances to ecs vpn endpoints"
  security_group_id = module.vpc_endpoints.vpc_endpoint_sgs[count.index].id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443

  source_security_group_id = var.asg_sg.id
}

module vpc_endpoints {
  # TODO
  # Use original source once this pull request has been merged:
  # https://github.com/plus3it/terraform-aws-tardigrade-vpc-endpoints/pull/14
//  source = "plus3it/terraform-aws-tardigrade-vpc-endpoints"
//  source = "github.com/evanstachowiak/terraform-aws-tardigrade-vpc-endpoints"
  source = "../../../terraform-aws-tardigrade-vpc-endpoints"

  create_sg_per_endpoint = var.create && var.create_sg_per_endpoint
  create_vpc_endpoints   = var.create
  sg_egress_rules        = []
  sg_ingress_rules       = []
  subnet_ids             = var.subnet_ids
  tags = {
    Name = "vpc all interface endpoints",
    env = terraform.workspace
  }
  vpc_endpoint_services = local.vpc_endpoint_services
}

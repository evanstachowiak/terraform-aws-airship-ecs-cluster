#
# iam module creates the necessary IAM roles for running an ECS Cluster
#
module "iam" {
  source = "./modules/iam/"

  iam_role_description = var.iam_role_description

  # name is used to create unique rolenames per ecs cluster
  name = var.name

  # default to true, when false no roles are created
  create = var.create_roles && var.create
}

# 
# The actual ECS Cluster  
#
resource "aws_ecs_cluster" "this" {
  count = var.create ? 1 : 0

  name = var.name

  lifecycle {
    create_before_destroy = true
  }
}

#
# autoscalinggroup delivers the Autoscaling group with EC2 Instances
#
module "autoscalinggroup" {
  source                     = "./modules/autoscalinggroup/"
  create                     = var.create_autoscalinggroup && var.create
  name                       = var.name
  cluster_properties         = var.cluster_properties
  vpc_security_group_ids     = var.vpc_security_group_ids
  iam_instance_profile       = module.iam.ecs_instance_profile
  tags                       = var.tags
  subnet_ids                 = var.subnet_ids
  enable_detailed_monitoring = var.enable_detailed_monitoring

  enable_mixed_cluster                   = var.enable_mixed_cluster
  mixed_cluster_instances_distribution   = var.mixed_cluster_instances_distribution
  mixed_cluster_launch_template_override = var.mixed_cluster_launch_template_override
}

#
# ecs_instance_scaling takes care of proper Autoscaling
#
module "ecs_instance_scaling" {
  source                           = "./modules/ecs_instance_autoscaling/"
  ecs_instance_scaling_create      = var.ecs_instance_scaling_create && var.create
  asg_name                         = module.autoscalinggroup.asg_name
  cluster_name                     = var.name
  ecs_instance_draining_lambda_arn = var.ecs_instance_draining_lambda_arn
  ecs_instance_scaling_properties  = var.ecs_instance_scaling_properties
}

#
# vpc creates the necessary VPC endpoints and security groups
# for the instances to communicate with the ECS service
#
module "vpc_endpoints" {
  source           = "./modules/vpc_endpoints/"
  name             = var.name
  create           = var.create_vpc_endpoints && var.create
  sg_egress_rules  = var.vpc_endpoint_sg_egress_rules
  sg_ingress_rules = var.vpc_endpoint_sg_ingress_rules
  asg_sg           = module.autoscalinggroup.asg_sg
  subnet_ids       = var.subnet_ids
}

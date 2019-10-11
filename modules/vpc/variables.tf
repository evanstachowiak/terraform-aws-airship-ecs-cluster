locals {
  # See here for exhaustive list:
  # https://docs.aws.amazon.com/general/latest/gr/rande.html#endpoint-tables
  vpc_endpoint_services = ["ecr.api", "ecs", "ecs-agent", "logs", "sns"]
}

variable "create" {
  type        = bool
  default     = true
  description = "Whether to create everything related"
}

variable "create_sg_per_endpoint" {
  type        = bool
  default     = true
  description = "Whether to create everything related"
}

variable "name" {
  type        = string
  description = "the short name of the environment that is used to define it"
}

variable "asg_sg" {
  description = "The security group for the cluster asg."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet_ids of the vpc to use."
}

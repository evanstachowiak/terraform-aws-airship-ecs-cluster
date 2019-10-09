output "asg_name" {
  description = "The name of the autoscaling group"
  value = element(
    concat(
      aws_autoscaling_group.homogenous.*.name,
      aws_autoscaling_group.heterogenous.*.name,
      [""],
    ),
    0,
  )
}

output "asg_sg" {
  description = "The sg of the autoscaling group"
  value = element(concat(aws_security_group.ecs_cluster_asg, [""],), 0,)
}

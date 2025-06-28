resource "aws_ecs_cluster" "oss_ecs_cluster_app" {
  depends_on = [
    aws_cloudwatch_log_group.oss_cw_log_group_app,
    aws_iam_service_linked_role.oss_iam_service_linked_role_ecs_service,
    aws_nat_gateway.oss_nat
  ]
  name = "OssEcsClusterApp"
  setting {
    name  = "containerInsights"
    value = "enhanced"
  }
  tags = {
    Name = "OssEcsClusterApp"
  }
}

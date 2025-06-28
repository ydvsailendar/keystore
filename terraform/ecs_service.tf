resource "aws_ecs_service" "oss_ecs_service_kafka_ui_public" {
  cluster                = aws_ecs_cluster.oss_ecs_cluster_app.id
  desired_count          = 1
  enable_execute_command = true
  launch_type            = "FARGATE"
  name                   = "OssEcsServiceKafkaUiPublic"
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.oss_sg_kafka_ui_public.id]
    subnets          = [aws_subnet.oss_public_subnet.id]
  }
  tags = {
    Name = "OssEcsServiceKafkaUiPublic"
  }
  task_definition = aws_ecs_task_definition.oss_ecs_task_def_kafka_ui.arn
}

resource "aws_ecs_service" "oss_ecs_service_kafka_private" {
  cluster                = aws_ecs_cluster.oss_ecs_cluster_app.id
  desired_count          = 1
  enable_execute_command = true
  launch_type            = "FARGATE"
  name                   = "OssEcsServiceKafkaPrivate"
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.oss_sg_kafka_private.id]
    subnets          = [aws_subnet.oss_app_subnet.id]
  }
  tags = {
    Name = "OssEcsServiceKafkaPrivate"
  }
  task_definition = aws_ecs_task_definition.oss_ecs_task_def_kafka.arn
  service_registries {
    registry_arn = aws_service_discovery_service.oss_sd_kafka.arn
  }
}

resource "aws_ecs_service" "oss_ecs_service_consumer_app" {
  cluster                = aws_ecs_cluster.oss_ecs_cluster_app.id
  desired_count          = 1
  enable_execute_command = true
  launch_type            = "FARGATE"
  name                   = "OssEcsServiceConsumerAppPrivate"
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.oss_sg_consumer_app_private.id]
    subnets          = [aws_subnet.oss_app_subnet.id]
  }
  tags = {
    Name = "OssEcsServiceConsumerAppPrivate"
  }
  task_definition = aws_ecs_task_definition.oss_ecs_task_def_consumer_app.arn
}

resource "aws_ecs_service" "oss_ecs_service_producer_app" {
  cluster                = aws_ecs_cluster.oss_ecs_cluster_app.id
  desired_count          = 1
  enable_execute_command = true
  launch_type            = "FARGATE"
  name                   = "OssEcsServiceProducerAppPrivate"
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.oss_sg_producer_app_private.id]
    subnets          = [aws_subnet.oss_app_subnet.id]
  }
  tags = {
    Name = "OssEcsServiceProducerAppPrivate"
  }
  task_definition = aws_ecs_task_definition.oss_ecs_task_def_producer_app.arn
}

resource "aws_ecs_service" "oss_ecs_service_dashboard_app" {
  cluster                = aws_ecs_cluster.oss_ecs_cluster_app.id
  desired_count          = 1
  enable_execute_command = true
  launch_type            = "FARGATE"
  name                   = "OssEcsServiceDashboardAppPublic"
  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.oss_sg_dashboard_app_public.id]
    subnets          = [aws_subnet.oss_public_subnet.id]
  }
  tags = {
    Name = "OssEcsServiceDashboardAppPublic"
  }
  task_definition = aws_ecs_task_definition.oss_ecs_task_def_dashboard_app.arn
}

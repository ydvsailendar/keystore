<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.100.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.oss_cw_log_group_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.oss_cw_log_group_rds_postgresql_logs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.oss_cw_log_group_vpc_flow](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.oss_cw_log_rds_group_error_logs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.oss_cw_log_rds_group_upgrade_logs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.oss_db_instance_rds](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.oss_db_subnet_group_keystore](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/db_subnet_group) | resource |
| [aws_ecr_repository.oss_ecr_repo_consumer](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.oss_ecr_repo_dashboard](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.oss_ecr_repo_migrator](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.oss_ecr_repo_producer](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.oss_ecs_cluster_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.oss_ecs_service_consumer_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.oss_ecs_service_dashboard_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.oss_ecs_service_kafka_private](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.oss_ecs_service_kafka_ui_public](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.oss_ecs_service_producer_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_consumer_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_dashboard_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_kafka_ui](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_migrator](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.oss_ecs_task_def_producer_app](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/ecs_task_definition) | resource |
| [aws_efs_access_point.oss_efs_access_point_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.oss_kafka_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.oss_mt_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/efs_mount_target) | resource |
| [aws_eip.oss_eip](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/eip) | resource |
| [aws_flow_log.oss_vpc_flow](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/flow_log) | resource |
| [aws_iam_policy.oss_iam_policy_ecs_task_exec_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.oss_iam_policy_ecs_task_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.oss_iam_policy_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.oss_iam_role_ecs_task](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role) | resource |
| [aws_iam_role.oss_iam_role_ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role) | resource |
| [aws_iam_role.oss_iam_role_ecs_task_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role) | resource |
| [aws_iam_role.oss_iam_role_rds_monitoring](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role) | resource |
| [aws_iam_role.oss_iam_role_vpc_flow](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.oss_iam_role_policy_vpc_flow](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.oss_iam_policy_attachment_ecs_task_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oss_iam_policy_attachment_ecs_task_kafka_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oss_iam_policy_attachment_rds_monitoring](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oss_iam_policy_attachment_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oss_iam_policy_attachment_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oss_iam_role_policy_attachment_ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_service_linked_role.oss_iam_service_linked_role_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/iam_service_linked_role) | resource |
| [aws_internet_gateway.oss_ig](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.oss_kms_alias_cw](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.oss_kms_alias_ecr](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.oss_kms_alias_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.oss_kms_alias_rds](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_alias) | resource |
| [aws_kms_alias.oss_kms_alias_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.oss_kms_key_cw](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_key) | resource |
| [aws_kms_key.oss_kms_key_ecr](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_key) | resource |
| [aws_kms_key.oss_kms_key_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_key) | resource |
| [aws_kms_key.oss_kms_key_rds](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_key) | resource |
| [aws_kms_key.oss_kms_key_secrets](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/kms_key) | resource |
| [aws_nat_gateway.oss_nat](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/nat_gateway) | resource |
| [aws_network_acl.oss_app_nacl](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl) | resource |
| [aws_network_acl.oss_db_az1_nacl](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl) | resource |
| [aws_network_acl.oss_db_az2_nacl](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl) | resource |
| [aws_network_acl.oss_public_nacl](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.oss_app_inbound_from_internet_on_empherial](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_app_outbound_to_internet_on_https](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_app_outbound_to_internet_on_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_db_az1_inbound_from_internet_on_ephemeral_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_db_az1_outbound_to_internet_on_ephemeral_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_db_az2_inbound_from_internet_on_ephemeral_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_db_az2_outbound_to_internet_on_ephemeral_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_public_inbound_from_internet_on_kafka_ui](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_public_outbound_to_internet_on_ephemeral_tcp](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.oss_public_outbound_to_internet_on_https](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/network_acl_rule) | resource |
| [aws_route.oss_app_rt_route_to_internet_via_nat](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route) | resource |
| [aws_route.oss_public_rt_route_to_internet_via_ig](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route) | resource |
| [aws_route_table.oss_app_rt](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table) | resource |
| [aws_route_table.oss_db_az1_rt](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table) | resource |
| [aws_route_table.oss_db_az2_rt](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table) | resource |
| [aws_route_table.oss_public_rt](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table) | resource |
| [aws_route_table_association.oss_app_rt_attach_to_app_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.oss_db_az1_rt_attach_to_db_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.oss_db_az2_rt_attach_to_db_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.oss_public_rt_attach_to_public_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_password_version](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_user_version](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.oss_sg_consumer_app_private](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_dashboard_app_public](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_kafka_private](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_kafka_ui_public](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_migrator_private](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_producer_app_private](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_security_group.oss_sg_rds_db](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.oss_ns](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.oss_sd_kafka](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/service_discovery_service) | resource |
| [aws_subnet.oss_app_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/subnet) | resource |
| [aws_subnet.oss_db_subnet_az1](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/subnet) | resource |
| [aws_subnet.oss_db_subnet_az2](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/subnet) | resource |
| [aws_subnet.oss_public_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/subnet) | resource |
| [aws_vpc.oss_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/vpc) | resource |
| [random_password.oss_random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.oss_random_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.oss_iam_policy_efs](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_allowed_account_ids"></a> [aws\_allowed\_account\_ids](#input\_aws\_allowed\_account\_ids) | aws variables | `list(string)` | n/a | yes |
| <a name="input_aws_max_retries"></a> [aws\_max\_retries](#input\_aws\_max\_retries) | n/a | `number` | `25` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | n/a | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
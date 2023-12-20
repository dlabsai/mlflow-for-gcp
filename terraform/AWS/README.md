# ML Flow implementation for GCP
## Files overview
`bucket.tf` - Bucket that will hold Ml Flow artifacts.

`db.tf` - Postgres database set up using RDS, database details are stored in parameters.

`ecr.tf` - ECR that will hold our container.

`ecs.tf` - Definition of an ECS service.

`gateways.tf` - NAT gateway and internet gateway.

`load_balancer.tf` - Load balancer and all elements it needs - listener and target group.

`local.tf` - Holds tags that are attached to all resources.

`main.tf` - General configuration for terraform.

`routing.tf` - Routing tables and routes association.

`sg.tf` - Security groups that limit traffic to different elements to ensure security.

`task_def.tf` - Task definition that is used to set up the service.

`users.tf` - User that MlFlow uses to list manage elements in bucket.

`variables.tf` - Input data.

`vpc.tf` - Setup for the vpc, subnetworks and subnetworks group (for database).

<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.4.0 |
## Resources

| Name | Type |
|------|------|
| [aws_alb_listener.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_db_instance.mlflow-db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecr_repository.mlflow_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.mlflow_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_eip.nat_ip_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.nat_ip_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_access_key.mlflow_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.access_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_user.mlflow_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.test-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lb.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener_rule.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.mlflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.mlflow_nat_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.mlflow_nat_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.db_subnet_association_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db_subnet_association_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnet_association_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnet_association_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_association_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet_association_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.mlflow-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.allow_ingress_from_vpn_dlabs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.db_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ecs_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_lb_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_lb_ports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.mlflow-bucket_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.mlflow_key_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.mlflow_key_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.mlflow_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.db_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.mlflow_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy.bucket_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.cloud_watch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `string` | `"mlflow-terraform"` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Cidr block of vpc | `string` | `"10.0.0.0/25"` | no |
| <a name="input_db_cidr_a"></a> [db\_cidr\_a](#input\_db\_cidr\_a) | n/a | `string` | `"10.0.0.32/28"` | no |
| <a name="input_db_cidr_b"></a> [db\_cidr\_b](#input\_db\_cidr\_b) | n/a | `string` | `"10.0.0.48/28"` | no |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | n/a | `string` | `"mlflow-test"` | no |
| <a name="input_ecs_task_name"></a> [ecs\_task\_name](#input\_ecs\_task\_name) | n/a | `string` | `"mlflow-test"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | `"test"` | no |
| <a name="input_internet_cidr"></a> [internet\_cidr](#input\_internet\_cidr) | Cidr block for the internet | `string` | `"0.0.0.0/0"` | no |
| <a name="input_private_cidr_a"></a> [private\_cidr\_a](#input\_private\_cidr\_a) | n/a | `string` | `"10.0.0.0/28"` | no |
| <a name="input_private_cidr_b"></a> [private\_cidr\_b](#input\_private\_cidr\_b) | n/a | `string` | `"10.0.0.16/28"` | no |
| <a name="input_public_cidr_a"></a> [public\_cidr\_a](#input\_public\_cidr\_a) | n/a | `string` | `"10.0.0.96/28"` | no |
| <a name="input_public_cidr_b"></a> [public\_cidr\_b](#input\_public\_cidr\_b) | n/a | `string` | `"10.0.0.112/28"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_your_vpn"></a> [your\_vpn](#input\_your\_vpn) | n/a | `string` | `"37.120.211.73/32"` | no |
| <a name="input_zone_a"></a> [zone\_a](#input\_zone\_a) | n/a | `string` | `"eu-central-1a"` | no |
| <a name="input_zone_b"></a> [zone\_b](#input\_zone\_b) | n/a | `string` | `"eu-central-1b"` | no |
The inputs need to be updated with correct values before the project can be started.
Either in variables.tf or in terraform.tfvars.
## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->

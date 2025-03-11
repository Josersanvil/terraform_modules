# Elastic File System (EFS) Module

This module creates an AWS EFS file system and mount targets in all subnets of a given VPC. So it can be mounted by any resource in the VPC.

## Usage

```hcl
data "aws_vpc" "default_vpc" {
  default = true
}

provider "aws" {
  region = "us-east-1"
}

module "my_file_system" {
    source = "./modules/elastic_file_system"

    vpc_id = data.aws_vpc.default_vpc.id
    file_system_name = "my-file-system"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.file_system_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [time_sleep.wait_for_efs_dns_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_subnets.vpc_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_file_system_name"></a> [file\_system\_name](#input\_file\_system\_name) | The name of the EFS file system | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which to create the EFS file system | `string` | n/a | yes |
| <a name="input_wait_for_dns_propagation"></a> [wait\_for\_dns\_propagation](#input\_wait\_for\_dns\_propagation) | If true, waits 90s for the DNS records to propagate after creating the mount targets | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_file_system_id"></a> [file\_system\_id](#output\_file\_system\_id) | n/a |
<!-- END_TF_DOCS -->

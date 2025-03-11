# Glue Catalogue from S3 data

This module creates a Glue Catalogue database and a Glue Crawler, which crawls data stored in S3 and creates the schemas of the tables in the Glue Catalogue per the data in S3 in a scheduled manner.

The catalog database can then be queried using Athena.

## Usage

```hcl
module "my_database" {
  source = "./modules/glue_database_s3"

  database_name    = "my-database-name"
  s3_bucket_name   = "my-s3-bucket"
  s3_bucket_prefix = "prefix/to/data"
}
```

> By default, the crawler will run daily at 00:00 UTC.

See [variables.tf](variables.tf) for additional configurable variables.

See [outputs.tf](outputs.tf) for the outputs that are exported by the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.catalog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_crawler.crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |
| [aws_iam_role.crawler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_crawler_schedule"></a> [crawler\_schedule](#input\_crawler\_schedule) | The schedule for the crawler | `string` | `"cron(0 0 * * ? *)"` | no |
| <a name="input_crawler_tables_prefix"></a> [crawler\_tables\_prefix](#input\_crawler\_tables\_prefix) | The prefix to add to the tables created by the crawler | `string` | `""` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the Glue catalog database to create. Usually the name of the project | `string` | n/a | yes |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the IAM role to use for the crawler. Defaults to FullETLAccess | `string` | `"FullETLAccess"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket where the data is stored | `string` | n/a | yes |
| <a name="input_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#input\_s3\_bucket\_prefix) | The path to where the data is stored in the S3 bucket | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_id"></a> [catalog\_id](#output\_catalog\_id) | Id of the Glue catalog in which the database resides |
| <a name="output_crawler_arn"></a> [crawler\_arn](#output\_crawler\_arn) | n/a |
| <a name="output_crawler_name"></a> [crawler\_name](#output\_crawler\_name) | n/a |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the Glue catalog database |
<!-- END_TF_DOCS -->

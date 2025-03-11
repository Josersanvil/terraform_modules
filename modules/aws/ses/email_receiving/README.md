# SES Email Receiving

Terraform module to configure [Email Receiving](https://docs.aws.amazon.com/ses/latest/dg/receiving-email.html) with Amazon SES.

It does not create any rule set or target. It only creates the necessary resources to receive emails to the specified domain.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.ses_receiving_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ses_domain_identity.identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ses_domain_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the domain to be used for SES. Should match the SES domain identity name. | `string` | n/a | yes |
| <a name="input_route53_hosted_zone_name"></a> [route53\_hosted\_zone\_name](#input\_route53\_hosted\_zone\_name) | The name of the Route53 hosted zone to be used for SES. If not provided, the domain name will be used. | `string` | `null` | no |
| <a name="input_subdomain_name"></a> [subdomain\_name](#input\_subdomain\_name) | The name of the subdomain to be used for the SES receiving record. If not provided, the domain name will be used. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

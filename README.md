# Terraform Modules

Collection of reusable [Terraform modules]((https://www.terraform.io/docs/modules/index.html)) to deploy resources in cloud infrastructure in a consistent way.

## Example Usage

Say you want to use the module in [./modules/aws/ecr_repository/](/modules/aws/ecr_repository/README.md),
you can write the following in your terraform configuration file:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      environment            = "Development"
      managed_by             = "Terraform"
    }
  }
}

module "my_app_ecr_repository" {
  # Provide the module in this repo as a source:
  source = "github.com/josersanvil/terraform_modules//modules/aws/ecr_repository"
  repository_name = "my_app"
}
```

## Development Setup

Requisites:

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [pre-commit](https://pre-commit.com/#install)
- [tflint](https://github.com/terraform-linters/tflint)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)

Install the pre-commit hooks with:

```sh
pre-commit install --install-hooks
```

See the [modules documentation](./modules/README.md) for instructions on how to write the modules.

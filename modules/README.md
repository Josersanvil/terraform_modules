# Terraform Modules

All modules should have a:

- `README.md` file that explains what the module does and how to use it.
  - The tags `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` must be present in all `README.md` files so documentation can be populated by [terraform-docs](https://github.com/terraform-docs/terraform-docs)
- A `variables.tf` file that defines the input variables for the module.
- An `outputs.tf` file that defines the output variables for the module.
- A `main.tf` file that contains the main logic for the module.

See the [Terraform documentation](https://www.terraform.io/docs/modules/index.html) for more information on writing modules.

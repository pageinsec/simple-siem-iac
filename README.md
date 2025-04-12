# Simple SIEM (WIP)
Terraform code is commonly provided by SIEM vendors to deploy associated resources, but this code is often shown in a way that will not scale well and creates unnecessary resources.

This repo shows one way to adjust the code from a few sample vendors to make it usuable in an enterprise environment where IaC is established.

No promises about the quality or that is will work as expected in your environment - this should serve more as a starting point than anything else. 

The setup is geared toward AWS, but the logic should be transferrable to other cloud providers.

Directions aren't provided for full setup - see the docs for setup information.

[Terraform](https://www.terraform.io/) will be used for the examples. [OpenTofu](https://opentofu.org/) examples may be added, but the two are generally fairly straightforward to switch between.

[Terragrunt](https://terragrunt.gruntwork.io/) stacks will be used to help keep the code DRY. There is additional functionality (like auto-init) that make Terragrunt a nice option for dealing with resource deployment.

 
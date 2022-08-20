# Terraform module and workspace
#### Activity
<div align="left">
  <a href="https://github.com/tchiunam/terraform-axolotl/commits/main">
    <img alt="Last Commit" src="https://img.shields.io/github/last-commit/tchiunam/terraform-axolotl" />
  </a>
  <a href="https://github.com/tchiunam/terraform-axolotl/issues?q=is%3Aissue+is%3Aclosed">
    <img alt="Closed Issues" src="https://img.shields.io/github/issues-closed/tchiunam/terraform-axolotl" />
  </a>
  <a href="https://github.com/tchiunam/terraform-axolotl/pulls?q=is%3Apr+is%3Aclosed">
    <img alt="Closed Pull Requests" src="https://img.shields.io/github/issues-pr-closed/tchiunam/terraform-axolotl" />
  </a>
</div>

#### License
<div align="left">
  <a href="https://opensource.org/licenses/MIT">
    <img alt="License: MIT" src="https://img.shields.io/github/license/tchiunam/terraform-axolotl" />
  </a>
</div>

#### Popularity
<div align="left">
  <img alt="Repo Stars" src="https://img.shields.io/github/stars/tchiunam/terraform-axolotl?style=social" />
  <img alt="Watchers" src="https://img.shields.io/github/watchers/tchiunam/terraform-axolotl?style=social" />
</div>

<br />

Terraform is a powerful tool for automating the maintenace of infrastructure.
Module allows you to create reusable blocks; Workspace allows you to push changes
across multiple environments. How to define an appropriate scope for each module?
What are the drawbacks when module and workspace are used? This repository a
good showcase.

#### Module
1. You'll have to use a lot of symlinks if you don't want to re-define the same variables.
1. When modules are highly dependent with each other, efforts to make the variable shared
is over the benefit you've gained from modularizing the resources.

#### Workspace
1. It requires your engineers to be very clear about which workspace he is running on.
If they mess it up by mistake, you are screwed.
1. In reality, it is very unlikey that you can have infrastructure to be the same
across environments. You will end up with environment specific logic anyway. Sticking to
workspace feature does not have too much advantage.

## Usage
### Working directory
You have to be in the application directory to run your code.
```
cd applciations/<name>
```

### Work on your changes
To list workspaces:
```
terraform workspace list
```

To select workspace:
```
terraform workspace select <workspace name>
```

To plan changes:
```
terraform plan -var-file ../../config/global.tfvars
```

To apply changes:
```
terraform apply -var-file ../../config/global.tfvars
```

#### See more  
1. [terraform-module](https://github.com/tchiunam/terraform-module) for modules used in this repository
1. [terragrunt-axolotl](https://github.com/tchiunam/terragrunt-axolotl) for Terragrunt implementation with Terraform module

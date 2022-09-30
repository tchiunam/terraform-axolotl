# Terraform module and workspace
#### Release
<div align="left">
  <a href="https://github.com/tchiunam/terraform-axolotl/releases">
    <img alt="Version" src="https://img.shields.io/github/v/release/tchiunam/terraform-axolotl?sort=semver" />
  </a>
  <a href="https://github.com/tchiunam/terraform-axolotl/releases">
    <img alt="Release Date" src="https://img.shields.io/github/release-date/tchiunam/terraform-axolotl" />
  </a>
  <img alt="Language" src="https://img.shields.io/github/languages/count/tchiunam/terraform-axolotl" />
  <img alt="Lines of Code" src="https://img.shields.io/tokei/lines/github/tchiunam/terraform-axolotl" />
  <img alt="File Count" src="https://img.shields.io/github/directory-file-count/tchiunam/terraform-axolotl" />
  <img alt="Repository Size" src="https://img.shields.io/github/repo-size/tchiunam/terraform-axolotl.svg?label=Repo%20size" />
</div>

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

# Terraform
Terraform is a powerful tool for automating the maintenace of infrastructure.
Module allows you to create reusable blocks; Workspace allows you to push changes
across multiple environments. How to define an appropriate scope for each module?
What are the drawbacks when module and workspace are used? This repository is a
good showcase.

You can implement IaC using Terraform in many ways. There are pros and cons with each
of the way you picked. They do not make too much differences if your scale is small however
there will be huge impact if you are going to co-manage a very dynamic environment with
many teams. Here are the _methods_ that you can use:

1. Enterprise
1. Repository
1. Workspace
    1. `terraform workspace select`
    1. `${terraform.workspace}`
1. State
1. Module
1. Local/Variable
1. Data
1. Terragrunt
    1. See [terragrunt-axolotl](https://github.com/tchiunam/terragrunt-axolotl) for example
1. CDK

# Things that you need to know
## Repository
It's good to have repository for each project even if they share the same base infrasctructure.
In AWS term, you should split your Terraform code in multiple repositories even if they
are in the same VPC. This allows the project members to manage the changes following
their project cycle. This can also prevent them from using Terraform code directly from
each other so you can avoid modifications that frequently impacts multiple businesses.

## Worksapce
Use Terraform Workspace from the start of your project. _Workspace_ allows you to build
Terraform code which is environment-agnostic. You may encounter difficulties if your
team is applying Terraform code changes manually because it's hard to make sure you
always switch to the correct environment. Have Terraform applied automatically with pipeline
is a solution.

In most case, it is very unlikey that you can have infrastructure to be the same
across environments. You will end up with environment specific logic. Therefore you
will need to have proper directory structure defined in order to use _workspace_ efficiently.

## Module
A good _module_ should have concrete input and output parameters defined. You should try to
minimize the number of input parameters by avoiding to read all attributes of a resource
as input. Instead, read the reference ID as an input and use _data_ to pull attributes inside
your _module_.

Keep your _module_ with a smaller scope. Expanding the scope of a _module_ too far will
reduce the usability of it. You can still create a _module_ as a composition of several
smaller _modules_.

Consider you are programming an API when developing a module. Pick the right variable type
and give meaning default values. Using a _module_ does not require you to understand
the custom data model involved from the source _variables_.

You can use symlinks if you are defining local modules but you don't want to re-define
variables all the time.

## State
_State_ is a kind of advanced level of breaking stuff in Terraform. If your team cannot
master _module_ well, don't try to break your Terraform code into too many small
_states_. This helps you make the judgement:
- _Module_ has versioning; It's good for managing items which are static
- _State_ has no versioning; It's good for manaing items which are dynamic

## Local / Variable
Do not use _variable_ all the time for configuration. There are cases that _local_ is much
better than _variable_. _Local_ is good for holding transient data. It's also good for
variables which are environment independent. You may not want to re-define your tfvars with
the same values in multiple environments again and again.

## Data
_Data_ is good for doing dependency injection of resources inside your Terraform code. By
using _data_, you are taking values from the actual resources in runtime. Always consider
to use _data_ before trying to use _variables_ (in tfvars) and _resources_. This gives you
the benefit of true Inversion of Control because the need of dependency graph built by
Terraform due to references of _resources is avoided.

Engineers can focus more on the data model of cloud platform rather than the custom data
model in tfvars.

## Resource Control Flow
### Infrastructure-oriented
It is very common that your team may be writing fancy `for_each` to build some common
resources repeatedly. This may look smart in certain but this comes with many disadvantages
when the scale becomes bigger. For example, you are using `for_each` to create IAM Roles by
looping through hundreds of items in tfvars. Each applications have their metadata configured
in that data model in tfvars. Same for other resource types, you are looping multiple lists
of data models. When you have to deploy one application, you will have to touch
multiple data models that span across all busniesses.

Infrastructure-oriented design is good for small scale. It is also good for managing
resources of a single business.


### Business-oriented
Designing Terraform code in a business-oriented way is one-step closer to
DevOps-as-a-service. Modulizing your data structure with business-line allows you
to clone and destroy without taking too much concern about affecting the others.

Another advantage of doing so is that you can leverage the code owner feature of source
control by CODEOWNERS under the corresponding folder of business services.


# Illustration
This example gives you the idea about the business-oriented design. The folder
structure enables the merge of branches if you are using the branch-per-environment
approach.

Of course, you should externalize your module with versioning.

```
-- SERVICE-DIRECTORY/
   -- CODEOWNERS
   -- modules/
      -- iam_role
         -- main.tf
         -- variables.tf
         -- outputs.tf
         -- provider.tf
         -- README
      -- security_group
         -- main.tf
         -- variables.tf
         -- outputs.tf
         -- provider.tf
         -- README
      -- business_application_1
         -- CODEOWNERS
         -- main.tf
            | module iam_role
            | module security_group
         -- variables.tf
         -- outputs.tf
         -- provider.tf
         -- README
   -- environments/
      -- dev/
         -- backend.tf
         -- main.tf
            | module business_application_1
      -- qa/
         -- backend.tf
         -- main.tf
      -- prod/
         -- backend.tf
         -- main.tf
```

# Usage
## Working directory
You have to be in the application directory to run your code.
```
cd applciations/<name>
```

## Work on your changes
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

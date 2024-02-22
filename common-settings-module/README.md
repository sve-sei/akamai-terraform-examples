# Common and specific functions usage across different properties with Akamai Terraform

# Setup

Steps provided in order of execution.

## Planned Repository Organization

We will progressively add to this, but the plan is to ultimately have:

```
.
├── configurations
│   └── site-a
|   └── site-b
└── modules
    └── common
```

## modules/common-settings

This is the rule tree template we will be using that contains the common settings.
It is intended as a skeleton sufficient to serve any domain with standard
needs, but individual websites can spin off a specialized configuration
from the template and override as needed.

There is no terraform action to do here, we just need to create the code
files as described in the folder.

Note that we are using `data.akamai_property_rules_builder` to describe
our rule tree programmatically in HCL:

```terraform
data "akamai_property_rules_builder" "this" {
  rules_v2023_01_05 {
    name      = "default"
    is_secure = false

    comments = <<-EOT
      The behaviors in the Default Rule apply to all requests for the property
      hostname(s) unless another rule overrides the Default Rule settings.
    EOT

    behavior {
      origin {
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = true
        # ...
      }
    }
}
```

## configurations/site-a and configurations/site-b

These are the two properties for site-a and site-b which will be using the common template together with some specific rules for both sites.
The site needs its own configuration and change management.

## Deploy the Terraform Infrastructure

Make sure you are in the directory with the code for sites-a or sites-b. Populate the variable data in terraform.tfvars.dist and execute:

terraform plan -var-file=terraform.tfvars.dist

This will show the plan which Terraform creates to deploy the infrastructure based on the Terraform code compared to the current state (if already exists).

To deploy the infrastructure from the plan, exeucte:

terraform apply -var-file=terraform.tfvars.dist

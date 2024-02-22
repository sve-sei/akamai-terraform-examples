data "akamai_group" "this" {
  group_name  = var.group_name
  contract_id = var.contract_id
}

resource "akamai_cp_code" "this" {
  name        = var.property_name
  contract_id = var.contract_id
  product_id  = var.product_id
  group_id    = data.akamai_group.this.id
}

# Ignore query string parameters in the URL for certain paths
data "akamai_property_rules_builder" "ignore-all-qsp" {
  rules_v2023_05_30 {
    name      = "Ignore all Query String Parameters"
    criterion {
      path {
        match_operator = "MATCHES_ONE_OF"
        values = ["/products/*", "/api/products/*"]
        match_case_sensitive = false
        normalize = true
      }
    }
    behavior {
      cache_key_query_params {
        behavior = "IGNORE_ALL"
      }
    }
  }
}

data "akamai_property_rules_builder" "this" {
  rules_v2023_05_30 {
    name      = "Site-B specific rules"
  
    children = [
      data.akamai_property_rules_builder.ignore-all-qsp.json,
    ]
  }
}

# Pass config specific rule overrides to common settings module
module "rule-builder" {
  source = "../../modules/common-settings"
  cpcode = akamai_cp_code.this.id
  overrides = [
    data.akamai_property_rules_builder.this.json
  ]
}

# Note how the property resource references the rule output of common settings module
resource "akamai_property" "this" {
  name        = var.property_name
  product_id  = var.product_id
  contract_id = var.contract_id
  group_id    = data.akamai_group.this.id
  rules       = module.rule-builder.rules
  rule_format = module.rule-builder.rule_format

  hostnames {
    cname_from             = var.cname_from
    cname_to               = var.cname_to
    cert_provisioning_type = "CPS_MANAGED"
  }
}

resource "akamai_property_activation" "this" {
  property_id                    = akamai_property.this.id
  contact                        = var.notify_emails
  version                        = akamai_property.this.latest_version
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
}

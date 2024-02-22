output "rules" {
  value = data.akamai_property_rules_builder.this.json
}

// source of truth for the rule format
output "rule_format" {
  value = "v2023-05-30"
}
terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">=5.0"
    }
  }
}

provider "akamai" {
  config_section = var.config_section
}

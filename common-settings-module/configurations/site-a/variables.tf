variable "product_id" {
  type    = string
  default = "prd_SPM"
}

variable "config_section" {
  type    = string
  default = null
}

variable "contract_id" {
  type = string
}

variable "group_name" {
  type = string
}

variable "property_name" {
  type = string
}

variable "cname_from" {
  type = string
}

variable "cname_to" {
  type = string
}

variable "notify_emails" {
  type = list(string)
  default = ["noreply@akamai.com"]
}
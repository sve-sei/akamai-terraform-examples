// Override rules to be included in the final property json
variable "overrides" {
  type    = list(any)
  default = []
}

variable "cpcode" {
  type = string
}
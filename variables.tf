# This is a unique value for your service in the class.
variable "fastly_service_name" {
  type = string
}

# Domains to be routed
variable "domains" {
  type    = list(string)
}

variable "force_ssl" {
  type = bool
  description = "redirect all non-HTTPS requests to HTTPS"
  default     = "false"
}

# Backend host
variable "backend" {
  type = list(object({
    name = string
    host = string
    port = number
    use_ssl = bool
    ssl_host = string
    healthcheck_path = string
    condition = string
    load_balance = object({
      enabled = bool
      weight = number
    })
  }))
}

terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.0"
    }
  }
}
variable "token_file_path" {
  type    = string
  default = "~/.creds/vultr/api-token"
}

locals {
  api_token = trimspace(file(var.token_file_path))
}

provider "vultr" {
  api_key = local.api_token
}

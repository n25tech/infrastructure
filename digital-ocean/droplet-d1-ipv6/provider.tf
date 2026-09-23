terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "token_file_path" {
  type    = string
  default = "~/.creds/digital-ocean/droplet"
}

locals {
  api_token = trimspace(file(var.token_file_path))
}

provider "digitalocean" {
  token = local.api_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "do-droplet"
}

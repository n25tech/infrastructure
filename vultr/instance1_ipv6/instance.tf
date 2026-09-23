variable "ssh_key" {
  type    = string
  default = "~/.ssh/vultr.pub"
}

resource "vultr_ssh_key" "vultr1" {
  name = "vultr1"
  ssh_key = trimspace(file(var.ssh_key))
}

data "vultr_reserved_ip" "existing_trading_ip" {
  filter {
    name   = "label"
    values = ["trading-ip"]
  }
}

resource "vultr_reserved_ip" "trading_ip" {
  region      = data.vultr_reserved_ip.existing_trading_ip.region
  ip_type     = data.vultr_reserved_ip.existing_trading_ip.ip_type
  instance_id = vultr_instance.instance.id
  label = "trading-ip"
}

resource "vultr_instance" "instance" {
  plan        = "vc2-1c-1gb"
  region      = "blr"
  os_id       = 2625
  enable_ipv6 = true
  ssh_key_ids = [vultr_ssh_key.vultr1.id]
  firewall_group_id = vultr_firewall_group.instance_fw.id
}



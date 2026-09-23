variable "ssh_key" {
  type    = string
  default = "~/.ssh/vultr.pub"
}

resource "vultr_ssh_key" "vultr1" {
  name = "vultr1"
  ssh_key = trimspace(file(var.ssh_key))
}

data "vultr_reserved_ip" "trading_ip" {
  filter {
    name   = "label"
    values = ["trading-ip"]
  }
}

resource "vultr_instance" "instance" {
  plan        = "vc2-1c-1gb"
  region      = "blr"
  os_id       = 2625
  enable_ipv6 = false
  ssh_key_ids = [vultr_ssh_key.vultr1.id]
  firewall_group_id = vultr_firewall_group.instance_fw.id
  reserved_ip_id = data.vultr_reserved_ip.trading_ip.id
}



resource "vultr_firewall_group" "instance_fw" {
  description = "Instance Firewall"
}

resource "vultr_firewall_rule" "ssh_v4" {
  firewall_group_id = vultr_firewall_group.instance_fw.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "Allow SSH IPv4"
}

resource "vultr_firewall_rule" "ssh_v6" {
  firewall_group_id = vultr_firewall_group.instance_fw.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::0"
  subnet_size       = 0
  port              = "22"
  notes             = "Allow SSH IPv6"
}

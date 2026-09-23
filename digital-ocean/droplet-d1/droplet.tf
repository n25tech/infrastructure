
resource "digitalocean_droplet" "d1" {
  image = "ubuntu-22-04-x64"
  name = "d1"
  region = "blr1"
  //size = "s-1vcpu-512mb"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  
  ipv6 = true
  user_data = <<EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - wireguard
      - wireguard-tools
    runcmd:
      - ps aux
  EOF
  monitoring = true
}

# Assign your pre-reserved IPv6 address to the Droplet
data "digitalocean_reserved_ipv6" "d1" {
  ip = "2400:6180:100:d0:0:1:92f4:f001"
}


resource "digitalocean_reserved_ipv6_assignment" "ipv6_assign" {
  ip  = data.digitalocean_reserved_ipv6.d1.ip
  droplet_id  = digitalocean_droplet.d1.id
}

# Configure DigitalOcean Cloud Firewall
resource "digitalocean_firewall" "d1-fw" {
  name = "d1-fw"

  droplet_ids = [digitalocean_droplet.d1.id]

  # Inbound rules: Allow SSH from anywhere (restrict this to your IP for better security)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Outbound rules: Allow all TCP/UDP/ICMP traffic out to the internet (IPv4 & IPv6)
  # Essential for connecting to INDmoney APIs over IPv6
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

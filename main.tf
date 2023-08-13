module "setup" {
  source = "./modules/my_setup"
}

# Specify the Hetzner 
Cloud provider for 
Terraform.
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

# Declare input variables to make the script flexible.
variable "ssh_key" {}       # To hold the SSH key for server access.
variable "api_token" {}     # For the Hetzner Cloud API token.

# Connect to Hetzner Cloud using the provided API token.
provider "hcloud" {
  token = var.api_token     # Authenticate with the given API token.
}

# Create a server named "web1".
resource "hcloud_server" "web1" {
  name        = "web1"             # Set the server's name.
  server_type = "cx21"             # Choose the server type.
  image       = "ubuntu-20.04"     # Select the operating system.
  location    = "fsn1"             # Pick the data center location.
  user_data   = <<-EOT
                #cloud-config
                ssh_authorized_keys:
                  - ${var.ssh_key}
                EOT                     
}

# Create more servers "web2", "web3", and "LB", reusing "web1" configuration.
resource "hcloud_server" "web2" {
  name        = "web2"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = "fsn1"
  user_data   = hcloud_server.web1.user_data  # Reuse "web1" user data.
}

resource "hcloud_server" "web3" {
  name        = "web3"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = "fsn1"
  user_data   = hcloud_server.web1.user_data  # Reuse "web1" user data.
}

resource "hcloud_server" "LB" {
  name        = "LB"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  location    = "fsn1"
  user_data   = hcloud_server.web1.user_data  # Reuse "web1" user data.
}

# Create a floating IP linked to the load balancer server.
resource "hcloud_floating_ip" "lb_floating_ip" {
  type          = "ipv4"
  home_location = "fsn1"
  server_id     = hcloud_server.LB.id  # Associate with the load balancer server.
}

# Set up a load balancer.
resource "hcloud_load_balancer" "load_balancer" {
  name       = "my-load-balancer"
  load_balancer_type = "lb11"
  location   = "fsn1"
  algorithm {
    type = "round_robin"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Define load balancer targets.
resource "hcloud_load_balancer_target" "load_balancer_target" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id  # Associate with the load balancer.
  type             = "server"
  server_id        = hcloud_server.LB.id                      # Associate with the load balancer server.
}

# Create a network.
resource "hcloud_network" "my_network" {
  name     = "my-network"
  ip_range = "10.0.0.0/16"
}

# Set up a network subnet.
resource "hcloud_network_subnet" "my_subnet" {
  network_id   = hcloud_network.my_network.id  # Associate with the network.
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# Define load balancer network settings.
resource "hcloud_load_balancer_network" "load_balancer_network" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id  # Associate with the load balancer.
  subnet_id        = hcloud_network_subnet.my_subnet.id     # Associate with the subnet.
}

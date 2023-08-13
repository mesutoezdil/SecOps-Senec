# Define outputs to provide useful information after Terraform deployment.

# Output the internal IP address of the "web1" server.
output "web1_ip" {
  description = "Internal IP of web1 server"              # Description of what's being output.
  value       = hcloud_server.web1.ipv4_address           # Retrieve the internal IP address of "web1".
}

# Output the internal IP address of the "web2" server.
output "web2_ip" {
  description = "Internal IP of web2 server"              # Description of what's being output.
  value       = hcloud_server.web2.ipv4_address           # Retrieve the internal IP address of "web2".
}

# Output the internal IP address of the "web3" server.
output "web3_ip" {
  description = "Internal IP of web3 server"              # Description of what's being output.
  value       = hcloud_server.web3.ipv4_address           # Retrieve the internal IP address of "web3".
}

# Output the external IP address of the load balancer (LB).
output "LB_ip" {
  description = "External IP of the load balancer (LB)"  # Description of what's being output.
  value       = hcloud_server.LB.ipv4_address             # Retrieve the external IP address of the load balancer.
}

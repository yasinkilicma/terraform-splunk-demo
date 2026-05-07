# ============================================================
# OUTPUTS.TF — Values displayed after terraform apply
# ============================================================

output "splunk_web_url" {
  description = "Splunk Web UI address"
  value       = "http://localhost:${var.splunk_web_port}"
}

output "splunk_hec_url" {
  description = "HTTP Event Collector address (for sending logs)"
  value       = "https://localhost:${var.splunk_hec_port}/services/collector"
}

output "splunk_credentials" {
  description = "Login credentials"
  value = {
    username = "admin"
    password = var.splunk_password
  }
  sensitive = true  # View with: terraform output -json splunk_credentials
}

output "container_name" {
  description = "Docker container name"
  value       = docker_container.splunk.name
}

output "network_name" {
  description = "Docker network name"
  value       = docker_network.splunk_net.name
}

output "getting_started" {
  description = "Getting started instructions"
  value       = <<-EOT
    ✅ Splunk is up and running!
    
    1. Open in browser: http://localhost:${var.splunk_web_port}
    2. Username: admin
    3. Password: run 'terraform output -json splunk_credentials'
    
    ⏳ Splunk may take 2-3 minutes on first startup.
  EOT
}

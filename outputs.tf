# ============================================================
# OUTPUTS.TF — Apply sonrası ekrana bilgi
# ============================================================

output "splunk_web_url" {
  description = "Splunk Web UI adresi"
  value       = "http://localhost:${var.splunk_web_port}"
}

output "splunk_hec_url" {
  description = "HTTP Event Collector adresi (log göndermek için)"
  value       = "http://localhost:${var.splunk_hec_port}/services/collector"
}

output "splunk_credentials" {
  description = "Giriş bilgileri"
  value = {
    username = "admin"
    password = var.splunk_password
  }
  sensitive = true  # terraform output -json ile görebilirsin
}

output "container_name" {
  description = "Docker container adı"
  value       = docker_container.splunk.name
}

output "network_name" {
  description = "Docker network adı"
  value       = docker_network.splunk_net.name
}

output "getting_started" {
  description = "Başlangıç talimatları"
  value       = <<-EOT
    ✅ Splunk kuruldu!
    
    1. Tarayıcıda aç: http://localhost:${var.splunk_web_port}
    2. Kullanıcı adı: admin
    3. Şifre: (terraform output -json splunk_credentials ile gör)
    
    ⏳ Splunk ilk açılışta 2-3 dakika sürebilir.
  EOT
}

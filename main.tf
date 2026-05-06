# ============================================================
# MAIN.TF — Splunk altyapısı
# Docker Network + Splunk Container
# ============================================================

# ── Docker Image ─────────────────────────────────────────────
# Splunk'un resmi Docker image'ını indir
resource "docker_image" "splunk" {
  name         = "splunk/splunk:${var.splunk_version}"
  keep_locally = true  # terraform destroy sonrası image'ı silme
  platform = "linux/amd64"
}

# ── Docker Network ───────────────────────────────────────────
# Splunk'un yaşadığı izole ağ
# İleride başka container eklenirse (örn. log üretici) buraya bağlanır
resource "docker_network" "splunk_net" {
  name   = "${var.project_name}-network"
  driver = "bridge"
}

# ── Splunk Container ─────────────────────────────────────────
resource "docker_container" "splunk" {
  name  = "${var.project_name}-splunk"
  image = docker_image.splunk.image_id

  # Splunk lisans sözleşmesini kabul et (zorunlu)
  env = [
    "SPLUNK_START_ARGS=--accept-license",
    "SPLUNK_GENERAL_TERMS=--accept-sgt-current-at-splunk-com",
    "SPLUNK_PASSWORD=${var.splunk_password}",
]

  # Port yönlendirme
  ports {
    internal = 8000   # Splunk Web UI
    external = var.splunk_web_port
  }

  ports {
    internal = 8088   # HTTP Event Collector (log göndermek için)
    external = var.splunk_hec_port
  }

  ports {
    internal = 9997   # Splunk Forwarder portu
    external = var.splunk_forwarder_port
  }

  # Ağa bağla
  networks_advanced {
    name = docker_network.splunk_net.name
  }

  # Veriyi kalıcı tut (container silinse bile loglar kaybolmaz)
  volumes {
    volume_name    = docker_volume.splunk_data.name
    container_path = "/opt/splunk/var"
  }

  # Container her zaman yeniden başlasın
  restart = "unless-stopped"

  # Splunk başlaması zaman alır, healthcheck ekle
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:8000/en-US/account/login"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 5
    start_period = "60s"
  }
}

# ── Splunk Data Volume ───────────────────────────────────────
# Logları ve konfigürasyonu kalıcı sakla
resource "docker_volume" "splunk_data" {
  name = "${var.project_name}-splunk-data"
}

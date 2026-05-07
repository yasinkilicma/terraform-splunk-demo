# ============================================================
# MAIN.TF — Splunk SOC Lab infrastructure
# Docker Network + Splunk Container
# ============================================================

# ── Docker Image ─────────────────────────────────────────────
# Pull official Splunk Docker image
resource "docker_image" "splunk" {
  name         = "splunk/splunk:${var.splunk_version}"
  keep_locally = true  # Keep image after terraform destroy
  platform     = "linux/amd64"
}

# ── Docker Network ───────────────────────────────────────────
# Isolated network for Splunk
# Additional containers (e.g. log generators) can join this network
resource "docker_network" "splunk_net" {
  name   = "${var.project_name}-network"
  driver = "bridge"
}

# ── Splunk Container ─────────────────────────────────────────
resource "docker_container" "splunk" {
  name  = "${var.project_name}-splunk"
  image = docker_image.splunk.image_id

  # Accept Splunk license agreement (required)
  env = [
    "SPLUNK_START_ARGS=--accept-license",
    "SPLUNK_GENERAL_TERMS=--accept-sgt-current-at-splunk-com",
    "SPLUNK_PASSWORD=${var.splunk_password}",
  ]

  # Port mappings
  ports {
    internal = 8000   # Splunk Web UI
    external = var.splunk_web_port
  }

  ports {
    internal = 8088   # HTTP Event Collector (for sending logs)
    external = var.splunk_hec_port
  }

  ports {
    internal = 9997   # Splunk Universal Forwarder port
    external = var.splunk_forwarder_port
  }

  # Attach to network
  networks_advanced {
    name = docker_network.splunk_net.name
  }

  # Persist data (logs survive container restarts)
  volumes {
    volume_name    = docker_volume.splunk_data.name
    container_path = "/opt/splunk/var"
  }

  # Always restart unless manually stopped
  restart = "unless-stopped"

  # Healthcheck — Splunk takes time to start
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:8000/en-US/account/login"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 5
    start_period = "60s"
  }
}

# ── Splunk Data Volume ───────────────────────────────────────
# Persist logs and configuration across restarts
resource "docker_volume" "splunk_data" {
  name = "${var.project_name}-splunk-data"
}

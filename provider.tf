# ============================================================
# PROVIDER.TF — Docker provider configuration
# Manages Docker containers directly (no LocalStack needed)
# Splunk will actually run and be accessible!
# ============================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # Docker Desktop socket path on Mac
  host = "unix:///var/run/docker.sock"
}

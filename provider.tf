# ============================================================
# PROVIDER.TF — Docker provider kullanıyoruz
# LocalStack değil, direkt Docker ile konuşuyoruz
# Splunk gerçekten çalışacak!
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
  # Mac'te Docker Desktop socket path
  host = "unix:///var/run/docker.sock"
}

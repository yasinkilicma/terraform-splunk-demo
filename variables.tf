# ============================================================
# VARIABLES.TF
# ============================================================

variable "project_name" {
  description = "Proje adı"
  type        = string
  default     = "soc-lab"
}

variable "splunk_version" {
  description = "Splunk Docker image versiyonu"
  type        = string
  default     = "latest"
}

variable "splunk_password" {
  description = "Splunk admin şifresi (min 8 karakter)"
  type        = string
  sensitive   = true  # terraform output'ta gizlenir
  default     = "SOClab123!"
}

variable "splunk_web_port" {
  description = "Splunk Web UI portu (tarayıcıdan erişim)"
  type        = number
  default     = 8000
}

variable "splunk_hec_port" {
  description = "HTTP Event Collector portu (log göndermek için)"
  type        = number
  default     = 8088
}

variable "splunk_forwarder_port" {
  description = "Splunk Universal Forwarder portu"
  type        = number
  default     = 9997
}

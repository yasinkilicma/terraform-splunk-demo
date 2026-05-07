# ============================================================
# VARIABLES.TF
# ============================================================

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "soc-lab"
}

variable "splunk_version" {
  description = "Splunk Docker image version"
  type        = string
  default     = "latest"
}

variable "splunk_password" {
  description = "Splunk admin password (min 8 characters)"
  type        = string
  sensitive   = true  # Hidden in terraform output
  default     = "SOClab123!"
}

variable "splunk_web_port" {
  description = "Splunk Web UI port (browser access)"
  type        = number
  default     = 8000
}

variable "splunk_hec_port" {
  description = "HTTP Event Collector port (for sending logs)"
  type        = number
  default     = 8088
}

variable "splunk_forwarder_port" {
  description = "Splunk Universal Forwarder port"
  type        = number
  default     = 9997
}

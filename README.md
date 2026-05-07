# 🔍 SOC Lab — Terraform + Docker + Splunk

> A fully functional Splunk SIEM environment deployed with Terraform and Docker.  
> Ideal local lab setup for SOC Analyst practice.

## 🏛️ Architecture

```
Terraform
    │
    ├── docker_network   →  soc-lab-network (bridge)
    ├── docker_volume    →  soc-lab-splunk-data (persistent storage)
    └── docker_container →  soc-lab-splunk
            │
            ├── Port 8000  →  Web UI (browser)
            ├── Port 8088  →  HTTP Event Collector (send logs)
            └── Port 9997  →  Universal Forwarder
```

## ⚙️ Setup

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.0.0`

### Quick Start

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy Splunk (downloads ~1.5GB image, may take a few minutes)
terraform apply

# Follow logs until Splunk is ready
docker logs soc-lab-splunk --follow
# Wait for: "Ansible playbook complete"

# Open in browser
open http://localhost:8000
```

### Credentials

```bash
# View credentials
terraform output -json splunk_credentials
```

- **Username:** `admin`
- **Password:** `SOClab123!` (configurable in variables.tf)

## 🔍 SOC Practice

### Send a Test Log via HEC

```bash
# Replace YOUR_HEC_TOKEN with the token from Splunk Web UI
# Settings → Data Inputs → HTTP Event Collector → New Token

curl -k https://localhost:8088/services/collector \
  -H "Authorization: Splunk YOUR_HEC_TOKEN" \
  -d '{"event": "Failed login attempt from IP 192.168.1.105", "sourcetype": "security", "source": "auth.log"}'
```

### Simulate Security Events

```bash
# Brute force simulation
curl -k https://localhost:8088/services/collector \
  -H "Authorization: Splunk YOUR_HEC_TOKEN" \
  -d '{"event": "Multiple failed logins from IP 10.0.0.55 - possible brute force", "sourcetype": "security"}'

# Privilege escalation simulation
curl -k https://localhost:8088/services/collector \
  -H "Authorization: Splunk YOUR_HEC_TOKEN" \
  -d '{"event": "sudo command executed by user john - privilege escalation attempt", "sourcetype": "security"}'

# Suspicious outbound connection
curl -k https://localhost:8088/services/collector \
  -H "Authorization: Splunk YOUR_HEC_TOKEN" \
  -d '{"event": "Outbound connection to known malicious IP 185.220.101.45 on port 4444", "sourcetype": "firewall"}'
```

### Basic SPL Queries

```spl
# View all events
index=*

# Events from the last hour
index=* earliest=-1h

# Search by specific IP
index=* "192.168.1.105"

# Count events by source type
index=* | stats count by sourcetype

# Security events only
index=* sourcetype=security | table _time, event

# Find failed logins
index=* "failed login" | stats count by host
```

## 🛑 Stop / Destroy

```bash
# Destroy all Terraform resources
terraform destroy

# Stop container only (data preserved)
docker stop soc-lab-splunk

# Start again
docker start soc-lab-splunk
```

## 📚 Next Steps

- [ ] Send sample logs via HEC
- [ ] Build a security dashboard
- [ ] Create alerts for specific events
- [ ] Use with TryHackMe SOC Level 1 labs
- [ ] Add a log generator container to the same Docker network

## 🔗 Resources

- [Splunk Docs](https://docs.splunk.com)
- [Splunk SPL Reference](https://docs.splunk.com/Documentation/Splunk/latest/SearchReference)
- [Terraform Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)

---
*This project was created for SOC Analyst training and SIEM practice.*

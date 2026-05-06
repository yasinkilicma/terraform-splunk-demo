# 🔍 SOC Lab — Terraform + Docker + Splunk

> Terraform ile Docker üzerinde tam çalışan bir Splunk SIEM ortamı.  
> SOC Analyst pratiği için ideal local lab kurulumu.

## 🏛️ Mimari

```
Terraform
    │
    ├── docker_network  →  soc-lab-network (bridge)
    ├── docker_volume   →  soc-lab-splunk-data (kalıcı depolama)
    └── docker_container → soc-lab-splunk
            │
            ├── Port 8000  →  Web UI (tarayıcı)
            ├── Port 8088  →  HTTP Event Collector (log gönder)
            └── Port 9997  →  Universal Forwarder
```

## ⚙️ Kurulum

### Gereksinimler
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Terraform](https://developer.hashicorp.com/terraform/install) `>= 1.0.0`

### Çalıştır

```bash
# 1. Terraform başlat
terraform init

# 2. Önizle
terraform plan

# 3. Kur (Splunk image ~1.5GB indirir, bekle)
terraform apply

# 4. Splunk hazır olana kadar bekle (~2-3 dakika)
docker logs soc-lab-splunk --follow

# 5. Tarayıcıda aç
open http://localhost:8000
```

### Giriş Bilgileri

```bash
# Şifreyi gör
terraform output -json splunk_credentials
```

- **Kullanıcı:** `admin`
- **Şifre:** `SOClab123!` (variables.tf'den değiştirilebilir)

## 🔍 SOC Pratiği

### Log Göndermek (HEC ile)

```bash
# Test logu gönder
curl -k http://localhost:8088/services/collector \
  -H "Authorization: Splunk YOUR_HEC_TOKEN" \
  -d '{"event": "Suspicious login attempt from 192.168.1.100", "sourcetype": "security"}'
```

### Splunk'ta Temel Sorgular

```spl
# Tüm eventleri gör
index=*

# Son 1 saatteki eventler
index=* earliest=-1h

# Belirli IP'yi ara
index=* src_ip="192.168.1.100"

# Hata logları
index=* level=error | stats count by host
```

## 🛑 Durdur / Sil

```bash
# Container'ı durdur (veri kaybolmaz)
terraform destroy

# Sadece container'ı durdur
docker stop soc-lab-splunk

# Tekrar başlat
docker start soc-lab-splunk
```

## 📚 Sonraki Adımlar

- [ ] Splunk'a örnek log gönder (HEC ile)
- [ ] Dashboard oluştur
- [ ] Alert kur — belirli event tetiklenince bildirim
- [ ] Splunk'u TryHackMe SOC Level 1 lablarıyla kullan

---
*Bu proje SOC Analyst eğitimi için oluşturulmuştur.*

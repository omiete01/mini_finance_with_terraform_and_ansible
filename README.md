# 🏦 Mini Finance Website – Infrastructure as Code (IaC) with Terraform and Ansible

A minimal, secure, and production-ready finance website deployed on **Microsoft Azure** using **Terraform** for infrastructure provisioning and **Ansible** for configuration management.

---

## ✅ Features

- Deployed on Azure with resource groups, virtual networks, and NSGs
- Ubuntu VM running Nginx + mini_finance web template for the finance dashboard
- Automated secure SSH access via key-based auth (no passwords)
- Firewall rules restricted to HTTP and trusted IPs
- Infrastructure versioned and repeatable via Terraform
- Configuration hardened and automated via Ansible
- No manual steps after initial setup

---

## 🚀 Prerequisites

Before you begin, ensure you have:

- ✅ **Azure Account** (Free tier works)
- ✅ **Azure CLI** installed: [`az login`](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- ✅ **Terraform** v1.5+ installed: [Install Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- ✅ **Ansible** v2.14+ installed: [Install Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- ✅ **Git** installed
- ✅ SSH key pair generated (`~/.ssh/id_rsa` or `id_ed25519`)

---

## 🔧 Deployment Steps

### 1. Clone the Repository

```bash
git clone https://github.com/omiete01/mini_finance_with_terraform_and_ansible.git
cd mini_finance_with_terraform_and_ansible
```

### 2. Configure Azure Authentication

Ensure you’re logged in via Azure CLI:

```bash
az login
```

Set your subscription (if you have multiple):

```bash
az account set --subscription "your-subscription-id"
```

### 3. Initialize Terraform

```bash
cd terraform
terraform init
```

> ⚠️ *Review `variables.tf` and create `terraform.tfvars` — update `location`, `admin_username`, and optionally `allowed_ip` for security.*

### 4. Apply the Infrastructure

```bash
terraform plan 
terraform apply
```

> This creates:  
> - Resource Group  
> - Virtual Network + Subnet  
> - Network Security Group (NSG) with restricted rules  
> - Ubuntu VM with public IP  
> - Public SSH key injection  

### 5. Run Ansible Playbook

Once the VM is provisioned (check `outputs.tf` for public IP), run Ansible:

```bash
cd ../ansible
ansible-playbook -i inventory.ini site.yml
```

> Ansible will:  
> - Install Nginx 
> - Deploy the finance website (static HTML) 
> - Harden SSH and enable automatic updates  

### 6. Access Your Site

After Ansible completes, open your browser and visit:

```
http://<public-ip-from-terraform-output>
```

You should see your Mini Finance Dashboard!

---

## 🔐 Security Notes

- SSH access is restricted to your public IP (configurable in `terraform.tfvars`)
- No root login; all access via sudo-enabled non-root user
- All secrets (e.g., API keys) are externalized — never committed
- Network policies follow least-privilege principles

---

## 📁 Directory Structure

```
.
├── terraform/           # Azure infrastructure as code
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/             # Configuration & app deployment
│   ├── inventory.ini
│   ├── roles/
│   └── site.yml
└── README.md
```

---

## 🧪 Testing & Validation

- Verify site loads over HTTP
- Check Nginx logs: `sudo tail -f /var/log/nginx/error.log`
- Confirm firewall rules: `az network nsg show --name <nsg-name> --resource-group <rg-name>`
- Test SSH access: `ssh <admin_username>@<public-ip>`


<img width="957" height="458" alt="image" src="https://github.com/user-attachments/assets/c12fa65f-ea23-475e-88db-6d133179f774" />


---

## 🙏 Acknowledgments

P.S. This post is part of the FREE DevOps Micro Internship (DMI) Cohort run by [Pravin Mishra](https://www.linkedin.com/in/pravin-mishra-aws-trainer/).
You can start your DevOps journey for free from his [YouTube Playlist](https://www.youtube.com/watch?v=qJD5UCdtjg4&list=PLVOdqXbCs7bX88JeUZmK4fKTq2hJ5VS89).
---

*Last updated: November 13, 2025*

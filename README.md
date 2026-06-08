# CS312 Course Project 2 - Automated Minecraft Server Pipeline
By Ethan Daon

## Background
 - **What**: Fully automated end-to-end cloud provisioning and configuration for a persistent Minecraft server on AWS.
 - **How**:
  - [Terraform](https://developer.hashicorp.com/terraform) provisions a custom Security Group and a `t3.medium` EC2 instance.
  - [Ansible](https://docs.ansible.com/) configures the system runtime environment via OpenSSH.
 - **Predecessor Fix**: Replaced the previous admin's unstable setup with a dedicated `systemd` wrapper.
___

## Requirements
### Local Workspace Tools
 - **OS Environment**: Linux or Windows Subsystem for Linux (WSL) with Ubuntu
 - **Software**: Terraform v1.5+, Ansible v2.15+, AWS CLI v2+, and OpenSSH Client (optional Nmap v7.9X+)

### Environment & Authentication Setup
Copy and paste your temporary AWS Academy tokens into a file:
```
[default]
aws_access_key_id=ASIAXXXXXXXXXXXXXXXX
aws_secret_access_key=keHFnbm8FH5NvpBhdEXAMPLEKEY
aws_session_token=IqkvwGZisdv...
```
Also, download the SSH kep (PEM) by clicking the button.
___

## Pipeline Diagram
[Local Machine] ──(1) terraform apply ──► [AWS Security Group & EC2]
       │
       └──(2) ansible-playbook ────────► [Configures: Java 21, Tmux, systemd]
___
## Deployment Steps:
 1) Initialize Terraform
```
terraform init
```
_Creates the necessary cloud provider infrastructure modules._
 2) Build Cloud Infrastructure
```
terraform apply -var="key_name=your-aws-key-name" -auto-approve
```
_Provisions the virtual server hardware, network rules, and outputs the public IP address._
 3) Automate Server Configuration
```
ansible-playbook -i "$(terraform output -raw public_ip)," -u ubuntu --private-key /path/to/your-key.pem playbook.yml
```
_Installs Java/tmux, accepts the game EULA, deploys the graceful-shutdown service, and boots the application._
 4) Verification & Connection
```
nmap -sV -Pn -p T:25565 <INSTANCE_PUBLIC_IP>
```
_Verify using Nmap or connect using the Minecraft client._
### Expected Output:
 - Port: `25565/tcp`
 - State: `open`
 - Version: `Minecraft 1.21.1`

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
Copy your temporary AWS Academy tokens.
```Ini
[default]
aws_access_key_id=ASIAXXXXXXXXXXXXXXXX
aws_secret_access_key=keHFnbm8FH5NvpBhdEXAMPLEKEY
aws_session_token=IqkvwGZisdv...
```
Then create a directory and file to paste them to
```bash
mkdir -p ~/.aws
nano ~/.aws/credentials
```
Also, download the SSH key (PEM) by clicking the button.
___

## Pipeline Diagram
```mermaid
graph TD
    Local[Local Workstation] -->|1. terraform apply| AWS[AWS Cloud Endpoint]
    AWS --> SG[Security Group Firewall]
    AWS --> EC2[EC2 Compute Instance]
    
    Local -->|2. ansible-playbook via SSH| EC2
    
    subgraph Target Machine State
        EC2 --> Java[OpenJDK 21 JRE]
        EC2 --> Tmux[Tmux Sockets]
        EC2 --> Systemd[Systemd Auto-Restart/Stop]
    end

    style Local fill:#f9f,stroke:#333,stroke-width:2px
    style AWS fill:#bbf,stroke:#333,stroke-width:2px
    style Target Machine State fill:#f96,stroke:#333,stroke-width:1px
```
___
## Deployment Steps
Step 1) Initialize Terraform
```bash
terraform init
```
_Creates the necessary cloud provider infrastructure modules._

Step 2) Build Cloud Infrastructure
```bash
terraform apply -var="key_name=your-aws-key-name" -auto-approve
```
_Provisions the virtual server hardware, network rules, and outputs the public IP address._

Step 3) Automate Server Configuration
```bash
ansible-playbook -i "<INSTANCE_PUBLIC_IP>," -u ubuntu --private-key /path/to/your-key.pem playbook.yml
```
_Installs Java/tmux, accepts the game EULA, deploys the graceful-shutdown service, and boots the application._

Step 4) Verification & Connection
```bash
nmap -sV -Pn -p T:25565 <INSTANCE_PUBLIC_IP>
```

_Verify using Nmap or connect using the Minecraft client._

### Expected Output:
 - Port: `25565/tcp`
 - State: `open`
 - Version: `Minecraft 1.21.1`

### Connection via Minecraft Client
1. Launch the **Minecraft Launcher** and start the game on version **1.21.1**.
2. Select **Multiplayer** from the main menu.
3. Click the **Direct Connection** or **Add Server** button.
4. Paste your `<INSTANCE_PUBLIC_IP>` into the **Server Address** field.
5. Click **Join Server** to connect to the server.

## References
 - [HashiCorp Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
 - [Ansible Playbook Directives Guide](https://docs.ansible.com/projects/ansible/latest/playbook_guide/index.html)
 - [Systemd Service Unit Specifications](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html?)
 - [GitHub Markdown Documentation Guide](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)

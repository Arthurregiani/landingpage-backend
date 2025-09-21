#!/bin/bash

# Server setup script for AWS EC2 Ubuntu
# Run this on the EC2 instance after first connection

set -e

echo "🚀 Configurando servidor AWS EC2 para Landing Page Backend..."

# Update system
echo "📦 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "🔧 Instalando pacotes essenciais..."
sudo apt install -y curl wget git htop ufw fail2ban unattended-upgrades

# Configure firewall
echo "🔒 Configurando firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# Install Docker
echo "🐳 Instalando Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
echo "📦 Instalando Docker Compose..."
sudo apt install -y docker-compose-plugin

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Configure unattended upgrades
echo "🔄 Configurando atualizações automáticas..."
echo 'Unattended-Upgrade::Automatic-Reboot "false";' | sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades

# Configure fail2ban
echo "🛡️  Configurando fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Create deployer user (optional, for better security)
echo "👤 Criando usuário deployer..."
sudo useradd -m -s /bin/bash deployer
sudo usermod -aG sudo deployer
sudo usermod -aG docker deployer

# Create SSH directory for deployer
sudo mkdir -p /home/deployer/.ssh
sudo cp /home/ubuntu/.ssh/authorized_keys /home/deployer/.ssh/
sudo chown -R deployer:deployer /home/deployer/.ssh
sudo chmod 700 /home/deployer/.ssh
sudo chmod 600 /home/deployer/.ssh/authorized_keys

# Create project directory
echo "📁 Criando diretório do projeto..."
sudo mkdir -p /opt/landingpage-backend/{config,logs,certs}
sudo chown -R ubuntu:ubuntu /opt/landingpage-backend

echo "✅ Configuração inicial concluída!"
echo ""
echo "🔄 Reinicie a conexão SSH para aplicar as mudanças do Docker:"
echo "   exit"
echo "   ssh -i sua-chave.pem ubuntu@18.228.193.155"
echo ""
echo "📋 Próximos passos:"
echo "   1. Reconecte via SSH"
echo "   2. Execute o script de deploy do seu computador local"
echo "   3. Configure um domínio (opcional) para HTTPS"
echo ""
echo "🔍 Verificar instalações:"
echo "   docker --version"
echo "   docker compose version"
echo "   sudo ufw status"
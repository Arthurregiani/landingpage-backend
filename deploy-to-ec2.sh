#!/bin/bash

# Deploy script for AWS EC2
# Usage: ./deploy-to-ec2.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
EC2_HOST="18.228.193.155"
EC2_USER="ubuntu"
PROJECT_NAME="landingpage-backend"
PROJECT_PATH="/opt/$PROJECT_NAME"
# SSH Key configuration - set this environment variable or adjust path
KEY_FILE="${AWS_SSH_KEY:-$HOME/.ssh/landingpage-backend-key.pem}"

echo -e "${GREEN}🚀 Iniciando deploy do Landing Page Backend para EC2...${NC}"

# Function to print step
print_step() {
    echo -e "\n${YELLOW}📋 $1${NC}"
}

# Check if key file exists
if [[ ! -f "$KEY_FILE" ]]; then
    echo -e "${RED}❌ Chave SSH não encontrada: $KEY_FILE${NC}"
    echo "Por favor, ajuste o caminho da chave no script ou coloque a chave em $KEY_FILE"
    exit 1
fi

print_step "1. Verificando conectividade com o servidor..."
ssh -i "$KEY_FILE" -o ConnectTimeout=10 "$EC2_USER@$EC2_HOST" "echo 'Conexão estabelecida com sucesso!'"

print_step "2. Criando estrutura de diretórios..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" "
    sudo mkdir -p $PROJECT_PATH/{config,logs,certs}
    sudo chown -R $EC2_USER:$EC2_USER $PROJECT_PATH
"

print_step "3. Enviando arquivos do projeto..."
rsync -avz --progress -e "ssh -i $KEY_FILE" \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'logs/*' \
    ./ "$EC2_USER@$EC2_HOST:$PROJECT_PATH/"

print_step "4. Configurando ambiente de produção..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" "
    cd $PROJECT_PATH
    
    # Stop existing containers
    if docker compose -f docker-compose.prod.yml ps -q > /dev/null 2>&1; then
        echo 'Parando containers existentes...'
        docker compose -f docker-compose.prod.yml down
    fi
    
    # Build and start new containers
    echo 'Construindo e iniciando containers...'
    docker compose -f docker-compose.prod.yml up -d --build
    
    # Wait for containers to be healthy
    echo 'Aguardando containers ficarem saudáveis...'
    sleep 10
    
    # Check health
    docker compose -f docker-compose.prod.yml ps
"

print_step "5. Testando API..."
sleep 5
if curl -f -s "http://$EC2_HOST:3000/health" > /dev/null; then
    echo -e "${GREEN}✅ API está respondendo corretamente!${NC}"
else
    echo -e "${RED}❌ API não está respondendo. Verificando logs...${NC}"
    ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" "docker logs landingpage-backend --tail 20"
    exit 1
fi

print_step "6. Configurando Nginx (se não existir)..."
ssh -i "$KEY_FILE" "$EC2_USER@$EC2_HOST" "
    if ! command -v nginx &> /dev/null; then
        echo 'Instalando Nginx...'
        sudo apt update
        sudo apt install -y nginx
        
        # Create nginx config
        sudo tee /etc/nginx/sites-available/$PROJECT_NAME > /dev/null << 'EOF'
server {
    listen 80;
    server_name $EC2_HOST ec2-18-228-193-155.sa-east-1.compute.amazonaws.com;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection \"1; mode=block\";

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # CORS headers for preflight
        if (\$request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' 'https://arthurjregiani.netlify.app';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
            add_header 'Access-Control-Allow-Headers' 'Content-Type, Authorization';
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
        }
    }

    location /health {
        proxy_pass http://localhost:3000/health;
        access_log off;
    }
}
EOF
        
        # Enable site
        sudo ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/
        sudo rm -f /etc/nginx/sites-enabled/default
        sudo nginx -t && sudo systemctl reload nginx
        sudo systemctl enable nginx
    else
        echo 'Nginx já está instalado'
    fi
"

print_step "7. Verificação final..."
sleep 3
echo -e "\n${GREEN}🎉 Deploy concluído com sucesso!${NC}"
echo -e "\n📍 URLs disponíveis:"
echo -e "   • Health Check: http://$EC2_HOST/health"
echo -e "   • API Endpoint: http://$EC2_HOST/api/contact"
echo -e "   • Direct IP: http://18.228.193.155/health"

echo -e "\n🔧 Comandos úteis:"
echo -e "   • Ver logs: ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'docker logs landingpage-backend -f'"
echo -e "   • Reiniciar: ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'cd $PROJECT_PATH && docker compose -f docker-compose.prod.yml restart'"
echo -e "   • Status: ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'cd $PROJECT_PATH && docker compose -f docker-compose.prod.yml ps'"

echo -e "\n⚠️  Para configurar HTTPS:"
echo -e "   1. Configure um domínio apontando para $EC2_HOST"
echo -e "   2. Execute: ssh -i $KEY_FILE $EC2_USER@$EC2_HOST 'sudo certbot --nginx -d seu-dominio.com'"

echo -e "\n✅ Teste a API localmente:"
echo -e "curl -X POST http://$EC2_HOST/api/contact \\"
echo -e "  -H 'Content-Type: application/json' \\"
echo -e "  -H 'Origin: https://arthurjregiani.netlify.app' \\"
echo -e "  -d '{\"name\":\"Teste\",\"email\":\"teste@exemplo.com\",\"message\":\"Mensagem de teste\"}'"
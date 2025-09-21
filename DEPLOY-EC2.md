# 🚀 Deploy do Landing Page Backend na AWS EC2

Este guia mostra como fazer o deploy do backend da landing page na instância EC2 da AWS.

## 📋 Informações da Instância EC2

- **ID da Instância**: `i-00131672d6a4d217a`
- **IP Público**: `18.228.193.155`
- **DNS Público**: `ec2-18-228-193-155.sa-east-1.compute.amazonaws.com`
- **Tipo**: `t3.micro` (São Paulo - sa-east-1)
- **Sistema Operacional**: Ubuntu Server

## 🔑 Pré-requisitos

1. **Chave SSH**: Certifique-se de ter a chave `.pem` da instância EC2
2. **Security Group**: Deve permitir acesso às portas:
   - `22` (SSH)
   - `80` (HTTP)
   - `443` (HTTPS)
3. **Domínio (Opcional)**: Para configurar HTTPS com Let's Encrypt

## 🚀 Processo de Deploy

### Passo 1: Configuração Inicial do Servidor

Conecte-se à instância EC2 e execute o setup inicial:

```bash
# Conectar via SSH
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155

# Baixar e executar script de configuração
curl -fsSL https://raw.githubusercontent.com/seu-usuario/landingpage-backend/main/setup-server.sh -o setup-server.sh
chmod +x setup-server.sh
./setup-server.sh
```

**Ou** copie o arquivo `setup-server.sh` manualmente:

```bash
scp -i /path/to/sua-chave.pem setup-server.sh ubuntu@18.228.193.155:~/
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155
./setup-server.sh
```

### Passo 2: Deploy da Aplicação

No seu computador local, execute o script de deploy:

```bash
# Ajuste o caminho da chave SSH no arquivo deploy-to-ec2.sh (linha 19)
# KEY_FILE="/path/to/sua-chave.pem"

# Execute o deploy
./deploy-to-ec2.sh
```

### Passo 3: Verificação

Após o deploy, verifique se tudo está funcionando:

```bash
# Health check
curl http://18.228.193.155/health

# Teste da API de contato
curl -X POST http://18.228.193.155/api/contact \
  -H 'Content-Type: application/json' \
  -H 'Origin: https://arthurjregiani.netlify.app' \
  -d '{
    "name": "Teste Deploy",
    "email": "teste@exemplo.com",
    "message": "Mensagem de teste do deploy"
  }'
```

## 🔒 Configuração HTTPS (Opcional)

### Com Domínio Próprio

Se você tiver um domínio, pode configurar HTTPS:

```bash
# Conectar ao servidor
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155

# Instalar Certbot
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
sudo certbot --nginx -d api.seu-dominio.com

# Verificar auto-renovação
sudo certbot renew --dry-run
```

### Atualizando DNS

Configure o DNS do seu domínio para apontar para o IP da EC2:
- Tipo: `A`
- Nome: `api` (ou subdomínio desejado)
- Valor: `18.228.193.155`

## 🔧 Comandos Úteis

### Monitoramento

```bash
# Ver logs da aplicação
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'docker logs landingpage-backend -f'

# Status dos containers
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'cd /opt/landingpage-backend && docker compose -f docker-compose.prod.yml ps'

# Uso de recursos
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'htop'
```

### Manutenção

```bash
# Reiniciar aplicação
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'cd /opt/landingpage-backend && docker compose -f docker-compose.prod.yml restart'

# Rebuild completo
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'cd /opt/landingpage-backend && docker compose -f docker-compose.prod.yml down && docker compose -f docker-compose.prod.yml up -d --build'

# Ver logs do Nginx
ssh -i /path/to/sua-chave.pem ubuntu@18.228.193.155 'sudo tail -f /var/log/nginx/access.log'
```

### Backup

```bash
# Backup dos logs
scp -i /path/to/sua-chave.pem -r ubuntu@18.228.193.155:/opt/landingpage-backend/logs/ ./backup-logs/

# Backup da configuração
scp -i /path/to/sua-chave.pem ubuntu@18.228.193.155:/opt/landingpage-backend/.env.prod ./backup.env.prod
```

## 🔄 Atualizações

Para fazer uma nova versão do deploy:

```bash
# 1. Faça as alterações no código localmente
# 2. Execute novamente o script de deploy
./deploy-to-ec2.sh
```

O script irá:
1. Parar os containers existentes
2. Enviar os novos arquivos
3. Reconstruir e reiniciar os containers
4. Verificar se tudo está funcionando

## 🌐 URLs Finais

Após o deploy concluído:

- **Health Check**: `http://18.228.193.155/health`
- **API de Contato**: `http://18.228.193.155/api/contact`
- **Com HTTPS**: `https://api.seu-dominio.com/api/contact`

## 🛠️ Troubleshooting

### Container não inicia
```bash
# Verificar logs
docker logs landingpage-backend

# Verificar se a porta está em uso
sudo netstat -tlnp | grep :3000

# Rebuild forçado
docker compose -f docker-compose.prod.yml down
docker system prune -f
docker compose -f docker-compose.prod.yml up -d --build
```

### Nginx retorna 502
```bash
# Verificar se o container está rodando
docker ps

# Verificar configuração do Nginx
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
```

### Email não está sendo enviado
```bash
# Verificar logs da aplicação
docker logs landingpage-backend | grep -i "email\|smtp\|mail"

# Testar credenciais do Gmail
# Certifique-se de que a senha de app está correta no .env.prod
```

### CORS Error
```bash
# Verificar se CLIENT_ORIGIN está correto no .env.prod
cat /opt/landingpage-backend/.env.prod | grep CLIENT_ORIGIN

# Deve ser exatamente: https://arthurjregiani.netlify.app
```

## 💰 Custos AWS

Com a instância `t3.micro`:
- **Free Tier**: 750 horas/mês gratuitas por 12 meses
- **Após Free Tier**: ~$10-15/mês
- **Tráfego**: Primeiros 15 GB/mês gratuitos

## 🔒 Segurança

O setup inclui:
- ✅ Firewall (UFW) configurado
- ✅ Fail2Ban para proteção SSH
- ✅ Usuário non-root para deploy
- ✅ Docker containers isolados
- ✅ Headers de segurança no Nginx
- ✅ Rate limiting na aplicação

## 📞 Suporte

Em caso de problemas:
1. Verifique os logs: `docker logs landingpage-backend`
2. Teste a conectividade: `curl http://18.228.193.155/health`
3. Verifique o status dos serviços: `sudo systemctl status nginx docker`
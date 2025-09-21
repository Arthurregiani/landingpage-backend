# 🚀 Landing Page Backend API

Backend API em Node.js para processar formulários de contato da landing page, com envio de emails automatizado via Gmail SMTP.

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com)

## 📋 Funcionalidades

- ✅ **API RESTful** para formulário de contato
- 📧 **Envio de emails** via Gmail SMTP com templates HTML
- 🛡️ **Segurança robusta** (Rate limiting, validação, sanitização)
- 🌐 **CORS configurado** para integração frontend/backend
- ⚡ **Deploy gratuito** no Render com HTTPS
- 📊 **Logs estruturados** e health check
- 🔒 **Validação rigorosa** de dados de entrada

## 🛠️ Tecnologias Utilizadas

- **Node.js** + **Express.js** - Framework web
- **Nodemailer** - Envio de emails
- **Express Validator** - Validação de dados
- **Helmet** - Segurança HTTP
- **Morgan** - Logging de requisições
- **CORS** - Cross-Origin Resource Sharing

## 📦 Instalação e Configuração

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd landingpage-backend
```

### 2. Instale as dependências
```bash
npm install
```

### 3. Configure as variáveis de ambiente
```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:

```env
# Server Configuration
PORT=5000

# CORS Configuration - URL do seu frontend
CLIENT_ORIGIN=https://seu-site.netlify.app

# Email Configuration
SMTP_SERVICE=gmail

# Gmail (remetente)
SMTP_USER=seu_email@gmail.com
SMTP_PASS=sua_senha_de_app_gmail

# Email de destino (Proton Mail para receber)
SMTP_TO=seu_email@proton.me

# Environment
NODE_ENV=development
```

### 4. Execute localmente
```bash
# Desenvolvimento (com nodemon)
npm run dev

# Produção
npm start
```

O servidor estará rodando em `http://localhost:5000`

### 4.1. Executar com Docker (Opcional)

```bash
# Build da imagem
docker build -t landingpage-backend .

# Executar container
docker run -d -p 5000:5000 --env-file .env --name landingpage-backend landingpage-backend

# Verificar logs
docker logs landingpage-backend

# Parar container
docker stop landingpage-backend
```

### 4.2. Executar com Docker Compose

```bash
# Iniciar todos os serviços
docker compose up -d

# Verificar status
docker compose ps

# Ver logs
docker compose logs -f landingpage-backend

# Parar todos os serviços
docker compose down
```

## 📧 Configuração de Email

### 📨 **Gmail SMTP** (Remetente - Recomendado)

Para usar Gmail como remetente:

1. **Ative a verificação em duas etapas**:
   - Acesse: https://myaccount.google.com/security
   - Ative "Verificação em duas etapas" (obrigatório)

2. **Gere uma senha de app**:
   - Acesse: https://myaccount.google.com/apppasswords
   - Selecione "Email" e "Outro (nome personalizado)"
   - Digite "Landing Page" como nome
   - Copie a senha gerada (16 caracteres sem espaços)

3. **Configure as variáveis**:
   ```env
   SMTP_SERVICE=gmail
   SMTP_USER=seu_email@gmail.com
   SMTP_PASS=sua_senha_de_app_gmail
   SMTP_TO=seu_email@proton.me
   ```

## 🚀 Deploy em Produção (Grátis)

Seu backend está configurado para deploy em **3 plataformas gratuitas**. Recomendamos **Render** por ser mais estável.

### 🌟 **Render** (Recomendado)

**Vantagens:** HTTPS automático, logs detalhados, sleep mode inteligente, melhor uptime

1. **Prepare o repositório:**
   ```bash
   git init
   git add .
   git commit -m "feat: containerized backend with Docker"
   git remote add origin https://github.com/SEU_USUARIO/landingpage-backend.git
   git push -u origin main
   ```

2. **Deploy no Render:**
   - Acesse: https://render.com
   - Clique "New" → "Web Service"
   - Conecte seu repositório GitHub
   - Configurações automáticas (usa `render.yaml`):
     ```yaml
     Runtime: Docker
     Build Command: (automático)
     Start Command: (automático)
     ```

3. **Configure variáveis de ambiente:**
   ```bash
   NODE_ENV=production
   CLIENT_ORIGIN=https://arthurjregiani.netlify.app
   SMTP_SERVICE=gmail
   SMTP_USER=arthurjregiani@gmail.com
   SMTP_PASS=sua_senha_de_app_gmail
   SMTP_TO=seu_email@proton.me
   ```

4. **URL final:** `https://landingpage-backend.onrender.com`

### 🚂 **Railway**

**Vantagens:** Deploy mais rápido, interface moderna, boa para desenvolvimento

1. **Deploy no Railway:**
   ```bash
   # Instalar CLI (opcional)
   npm install -g @railway/cli
   
   # Ou usar interface web:
   # https://railway.app → "Deploy from GitHub"
   ```

2. **Configuração automática via `railway.json`**

3. **Configurar variáveis no dashboard Railway**

### ✈️ **Fly.io**

**Vantagens:** Global edge deployment, containers nativos, boa performance

1. **Instalar Fly CLI:**
   ```bash
   # Linux/Mac
   curl -L https://fly.io/install.sh | sh
   ```

2. **Deploy:**
   ```bash
   # Login
   flyctl auth login
   
   # Deploy (usa fly.toml)
   flyctl deploy
   
   # Configurar variáveis
   flyctl secrets set SMTP_USER=seu_email@gmail.com
   flyctl secrets set SMTP_PASS=sua_senha_de_app
   # ... outras variáveis
   ```

### 📊 **Comparação das Plataformas**

| Recurso | Render | Railway | Fly.io |
|---------|--------|---------|--------|
| **Preço** | Grátis | Grátis ($5 crédito) | Grátis |
| **HTTPS** | ✅ Automático | ✅ Automático | ✅ Automático |
| **Logs** | ✅ Excelente | ✅ Bom | ✅ Bom |
| **Uptime** | ✅ Alto | ⚠️ Médio | ✅ Alto |
| **Sleep Mode** | ⚠️ Sim (15 min) | ⚠️ Sim (5 min) | ✅ Não |
| **Facilidade** | ✅ Muito Fácil | ✅ Fácil | ⚠️ Intermediário |
| **Região BR** | ❌ Não | ❌ Não | ✅ São Paulo |

### 🔗 **Atualizar URL no Frontend**

Após o deploy, atualize a URL no seu `script.js`:

```javascript
// Substitua pela URL real do seu deploy
const BACKEND_URL = 'https://landingpage-backend.onrender.com/api/contact';
// ou
const BACKEND_URL = 'https://seu-app.up.railway.app/api/contact';
// ou 
const BACKEND_URL = 'https://landingpage-backend.fly.dev/api/contact';
```

### 🔒 **Proton Mail** (Alternativa como Remetente)

Para usar Proton Mail como remetente:

1. **Ative Two-Factor Authentication**:
   - Vá em Settings → Go to settings → Security → Two-factor authentication
   - Configure 2FA (obrigatório para app passwords)

2. **Crie App Password**:
   - Vá em Settings → Go to settings → Security → App passwords
   - Clique em "Generate app password"
   - Selecione "Mail" como app
   - Copie a senha gerada (16 caracteres)

3. **Configure as variáveis**:
   ```env
   SMTP_SERVICE=proton
   SMTP_USER=seu_email@proton.me
   SMTP_PASS=sua_app_password_de_16_caracteres
   SMTP_TO=email_destino@proton.me
   ```

## 🌐 Deploy no Render (Gratuito)

### Opção 1: Deploy Automático
1. Faça fork deste repositório
2. Conecte sua conta GitHub no [Render](https://render.com)
3. Crie um novo "Web Service"
4. Configure as variáveis de ambiente no dashboard

### Opção 2: Deploy via render.yaml
O arquivo `render.yaml` já está configurado. Apenas:
1. Faça push para o repositório
2. Configure as variáveis de ambiente no dashboard do Render

### Variáveis de Ambiente no Render
Configure estas variáveis no dashboard:

**Gmail → Proton Mail (Recomendado):**
```
NODE_ENV=production
CLIENT_ORIGIN=https://seu-frontend-domain.com
SMTP_SERVICE=gmail
SMTP_USER=seu_email@gmail.com
SMTP_PASS=sua_senha_de_app_gmail
SMTP_TO=seu_email@proton.me
```

**Proton Mail → Gmail (Alternativa):**
```
NODE_ENV=production
CLIENT_ORIGIN=https://seu-frontend-domain.com
SMTP_SERVICE=proton
SMTP_USER=seu_email@proton.me
SMTP_PASS=sua_app_password_proton
SMTP_TO=seu_gmail@gmail.com
```

## 📝 API Reference

### Health Check
```http
GET /health
```

**Response:**
```json
{
  "status": "OK",
  "timestamp": "2025-09-21T02:19:50.000Z",
  "uptime": 123.456,
  "service": "Landing Page Contact API"
}
```

### Enviar Mensagem de Contato
```http
POST /api/contact
```

**Body:**
```json
{
  "name": "João Silva",
  "email": "joao@exemplo.com", 
  "message": "Olá! Gostaria de saber mais sobre seus serviços."
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Mensagem enviada com sucesso! Retornaremos em breve.",
  "messageId": "<message-id@gmail.com>"
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Dados inválidos",
  "errors": [
    {
      "field": "name",
      "message": "Nome é obrigatório",
      "value": ""
    }
  ]
}
```

### Info do Endpoint
```http
GET /api/contact
```

Retorna informações sobre a API de contato.

## 🔒 Segurança

- **Rate Limiting**: 100 requisições por 15 minutos por IP
- **Helmet.js**: Headers de segurança HTTP
- **Validação rigorosa**: Sanitização de todos os inputs
- **CORS configurado**: Apenas origens autorizadas
- **Logs estruturados**: Para monitoramento e debug
- **Container security**: Execução em ambiente isolado

## 📊 Monitoramento e Logs

### **Render**
```bash
# Ver logs em tempo real no dashboard
# Ou via CLI:
npx @render/cli logs --service landingpage-backend --follow
```

### **Railway**
```bash
# Ver logs no dashboard Railway
# Ou via CLI:
railway logs --follow
```

### **Fly.io**
```bash
# Ver logs
flyctl logs

# Monitorar em tempo real
flyctl logs --follow

# Status da aplicação
flyctl status
```

### **Health Check**
Todas as plataformas monitoram automaticamente via `/health`:
```bash
curl https://sua-app.onrender.com/health
# Resposta: {"status":"OK","timestamp":"...","uptime":123}
```

## 🧪 Testando a API

### Com curl:
```bash
curl -X POST https://seu-backend.onrender.com/api/contact \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Teste",
    "email": "teste@exemplo.com",
    "message": "Mensagem de teste do sistema"
  }'
```

### Com Postman:
1. Método: `POST`
2. URL: `https://seu-backend.onrender.com/api/contact`
3. Headers: `Content-Type: application/json`
4. Body: JSON com name, email, message

## 🔧 Integração Frontend

Atualize seu JavaScript no frontend:

```javascript
const form = document.querySelector('form');

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  
  const formData = new FormData(e.target);
  const data = {
    name: formData.get('name'),
    email: formData.get('email'),
    message: formData.get('message')
  };
  
  try {
    const response = await fetch('https://seu-backend.onrender.com/api/contact', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });
    
    const result = await response.json();
    
    if (result.success) {
      alert('✅ ' + result.message);
      e.target.reset();
    } else {
      alert('❌ ' + result.message);
    }
  } catch (error) {
    alert('❌ Erro ao enviar mensagem. Tente novamente.');
  }
});
```

## 📊 Logs e Monitoramento

O sistema gera logs estruturados:
- ✅ Tentativas de contato (nome e email)
- 📧 Emails enviados com sucesso
- ❌ Erros de validação e envio
- 🔒 Rate limiting ativado

## 🐛 Troubleshooting

### 📧 **Email não está sendo enviado**
1. **Verifique credenciais Gmail:**
   ```bash
   # Certifique-se de que SMTP_USER e SMTP_PASS estão corretos
   # SMTP_PASS deve ser a "senha de app" de 16 caracteres
   ```
2. **Teste localmente:**
   ```bash
   curl -X POST http://localhost:5000/api/contact \
     -H "Content-Type: application/json" \
     -d '{"name":"Teste","email":"teste@example.com","message":"Teste"}'
   ```
3. **Verifique logs da plataforma**

### 🌐 **CORS Error no Frontend**
1. **Configure CLIENT_ORIGIN corretamente:**
   ```bash
   # ❌ Errado
   CLIENT_ORIGIN=meusite.com
   CLIENT_ORIGIN=https://meusite.com/
   
   # ✅ Correto  
   CLIENT_ORIGIN=https://meusite.com
   ```
2. **Para desenvolvimento local:**
   ```bash
   CLIENT_ORIGIN=http://localhost:3000
   ```

### 🚫 **Rate Limit ativado**
```bash
# Limite padrão: 100 requests per 15 minutos por IP
# Para aumentar temporariamente, edite server.js:

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 200, // ← Aumentar aqui
});
```

### 🐳 **Problemas com Docker**

**Build falhando:**
```bash
# Limpar cache Docker
docker system prune -af

# Build com logs detalhados
docker build --no-cache --progress=plain -t landingpage-backend .
```

**Container não inicia:**
```bash
# Ver logs do container
docker logs landingpage-backend

# Executar interativamente para debug
docker run -it --rm landingpage-backend sh
```

### 🚀 **Problemas no Deploy**

**Render:**
```bash
# 1. Verificar se render.yaml está correto
# 2. Checar variáveis de ambiente no dashboard
# 3. Ver logs: Dashboard → Service → Logs
```

**Railway:**
```bash
# 1. Verificar railway.json
# 2. Checar build logs no dashboard
# 3. Testar health check: https://seu-app.up.railway.app/health
```

**Fly.io:**
```bash
# Debug deploy
flyctl deploy --verbose

# Verificar status
flyctl status

# Ver configuração
flyctl config show
```

### 📋 **Logs Úteis**

```bash
# Logs que indicam sucesso:
"✅ Servidor de email configurado com sucesso"
"📧 Email enviado com sucesso: <message-id>"
"🚀 Servidor rodando na porta X"

# Logs de erro comuns:
"❌ Erro na configuração do email: Invalid login"
"❌ Missing credentials for PLAIN"
"CORS Error: Access to fetch blocked"
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit: `git commit -m 'Adiciona nova funcionalidade'`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença ISC. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Arthur J. Regiani**
- GitHub: [@Arthurregiani](https://github.com/Arthurregiani)
- Email: arthurregiani@gmail.com

---

⭐ **Feito com carinho para facilitar o contato entre você e seus clientes!**
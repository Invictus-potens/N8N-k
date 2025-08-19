# N8N Docker Setup para Railway

Este projeto contém uma configuração Docker otimizada para o n8n, preparada para deploy no Railway.

## 🚀 Características

- **Dockerfile otimizado** com Node.js 18 Alpine
- **Configuração de segurança** com usuário não-root
- **Compatível com Railway** para deploy automático
- **Configurações de ambiente** pré-definidas
- **Volume persistente** para dados do n8n

## 📋 Pré-requisitos

- Docker e Docker Compose instalados
- Conta no Railway (para deploy)

## 🐳 Execução Local

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd N8N-k
```

### 2. Execute com Docker Compose
```bash
docker-compose up -d
```

### 3. Acesse o n8n
Abra http://localhost:5678 no seu navegador

**Credenciais padrão:**
- Usuário: `admin`
- Senha: `admin`

## 🚂 Deploy no Railway

### 1. Conecte seu repositório
- Faça push do código para o GitHub
- No Railway, conecte o repositório

### 2. Configure as variáveis de ambiente
No Railway, adicione estas variáveis de ambiente:

```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=senha500
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=https
DB_TYPE=sqlite
DB_SQLITE_DATABASE=/home/node/.n8n/database.sqlite
N8N_USER_MANAGEMENT_DISABLED=false
N8N_TEMPLATES_ENABLED=true
N8N_ONBOARDING_FLOW_DISABLED=true
NODE_ENV=production
WEBHOOK_URL=https://seu-dominio.railway.app/
EXECUTIONS_PROCESS=main
EXECUTIONS_MODE=regular
LOG_LEVEL=info
GENERIC_TIMEZONE=UTC
```

### 3. Deploy automático
O Railway detectará automaticamente o Dockerfile e fará o build.

## 🔧 Configurações

### Variáveis de Ambiente Importantes

| Variável | Descrição | Padrão |
|----------|-----------|---------|
| `N8N_BASIC_AUTH_ACTIVE` | Ativa autenticação básica | `true` |
| `N8N_BASIC_AUTH_USER` | Usuário admin | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Senha admin | `senha500` |
| `DB_TYPE` | Tipo de banco de dados | `sqlite` |
| `N8N_HOST` | Host de binding | `0.0.0.0` |
| `N8N_PORT` | Porta do serviço | `5678` |

### Banco de Dados
Por padrão, usa SQLite. Para produção, recomenda-se PostgreSQL:

```yaml
# Descomente no docker-compose.yml
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=n8n_password
```

## 📁 Estrutura do Projeto

```
N8N-k/
├── Dockerfile          # Configuração Docker
├── docker-compose.yml  # Compose para desenvolvimento
├── .dockerignore       # Arquivos ignorados no build
├── railway.json        # Configuração Railway
├── package.json        # Dependências Node.js
└── README.md          # Este arquivo
```

## 🛠️ Comandos Úteis

### Docker
```bash
# Build da imagem
docker build -t n8n .

# Executar container
docker run -p 5678:5678 n8n

# Ver logs
docker logs -f n8n
```

### Docker Compose
```bash
# Iniciar serviços
docker-compose up -d

# Parar serviços
docker-compose down

# Ver logs
docker-compose logs -f n8n

# Rebuild
docker-compose up --build
```

## 🔒 Segurança

- Usuário não-root no container
- Autenticação básica ativada
- Portas expostas limitadas
- Volumes isolados

## 📝 Notas

- O n8n será acessível na porta 5678
- Dados são persistidos em volume Docker
- Configurações podem ser alteradas via variáveis de ambiente
- Recomenda-se usar HTTPS em produção

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.

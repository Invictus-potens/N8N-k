# Use Node.js 20 Alpine como base para compatibilidade com n8n
FROM node:20-alpine

# Instalar dependências necessárias
RUN apk add --no-cache \
    dumb-init \
    su-exec \
    tzdata

# Criar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -D -s /bin/sh -u 1001 -G nodejs n8n

# Definir diretório de trabalho
WORKDIR /home/node/.n8n

# Copiar package.json e package-lock.json primeiro para cache de layers
COPY package*.json ./

# Instalar dependências
RUN npm ci --only=production && npm cache clean --force

# Copiar código fonte
COPY . .

# Mudar propriedade dos arquivos para o usuário n8n
RUN chown -R n8n:nodejs /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n

# Expor porta padrão do n8n
EXPOSE 5678

# Definir variáveis de ambiente padrão
ENV N8N_HOST=0.0.0.0 \
    N8N_PORT=5678 \
    N8N_PROTOCOL=http \
    NODE_ENV=production \
    DB_TYPE=sqlite \
    DB_SQLITE_DATABASE=/home/node/.n8n/database.sqlite \
    WEBHOOK_URL=http://localhost:5678/ \
    EXECUTIONS_PROCESS=main \
    EXECUTIONS_MODE=regular \
    LOG_LEVEL=info \
    GENERIC_TIMEZONE=UTC \
    # Configurações de multiusuário
    N8N_USER_MANAGEMENT_DISABLED=false \
    N8N_USER_MANAGEMENT_JWT_SECRET=your-super-secret-jwt-token \
    N8N_USER_MANAGEMENT_SMTP_HOST= \
    N8N_USER_MANAGEMENT_SMTP_PORT=587 \
    N8N_USER_MANAGEMENT_SMTP_USER= \
    N8N_USER_MANAGEMENT_SMTP_PASS= \
    N8N_USER_MANAGEMENT_SMTP_SENDER= \
    # Configurações de autenticação
    N8N_BASIC_AUTH_ACTIVE=false \
    N8N_AUTH_EXCLUDE_ENDPOINTS=metrics,healthz,health \
    # Configurações de templates e onboarding
    N8N_TEMPLATES_ENABLED=true \
    N8N_ONBOARDING_FLOW_DISABLED=true

# Usar dumb-init para gerenciar sinais corretamente
ENTRYPOINT ["dumb-init", "--"]

# Comando padrão
CMD ["su-exec", "n8n", "sh", "-c", "echo 'Starting n8n...' && npm start"]

# Use Node.js 18 Alpine como base para menor tamanho
FROM node:18-alpine

# Instalar dependências necessárias
RUN apk add --no-cache \
    dumb-init \
    su-exec \
    tzdata

# Criar usuário não-root para segurança
RUN addgroup -g 1000 -S nodejs && \
    adduser -D -s /bin/sh -u 1000 -G nodejs n8n

# Definir diretório de trabalho
WORKDIR /home/node/.n8n

# Copiar package.json e package-lock.json primeiro para cache de layers
COPY package*.json ./

# Instalar dependências
RUN npm ci --only=production && npm cache clean --force

# Copiar código fonte
COPY . .

# Mudar propriedade dos arquivos para o usuário n8n
RUN chown -R n8n:nodejs /home/node/.n8n

# Expor porta padrão do n8n
EXPOSE 5678

# Definir variáveis de ambiente padrão
ENV N8N_BASIC_AUTH_ACTIVE=true \
    N8N_BASIC_AUTH_USER=admin \
    N8N_BASIC_AUTH_PASSWORD=admin \
    N8N_HOST=0.0.0.0 \
    N8N_PORT=5678 \
    N8N_PROTOCOL=http \
    N8N_USER_MANAGEMENT_DISABLED=false \
    N8N_TEMPLATES_ENABLED=true \
    N8N_ONBOARDING_FLOW_DISABLED=true \
    NODE_ENV=production

# Usar dumb-init para gerenciar sinais corretamente
ENTRYPOINT ["dumb-init", "--"]

# Comando padrão
CMD ["su-exec", "n8n", "n8n", "start"]

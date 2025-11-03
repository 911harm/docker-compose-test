# Dockerfile (Next.js server)
FROM node:20-alpine AS builder
WORKDIR /app

# copiar package.json y lock para instalar deps
COPY package*.json ./
# Opcional: agregar cachebust arg para forzar rebuild cuando quieras
ARG CACHEBUST=1
RUN npm ci

# copiar resto del código y construir
COPY . .
RUN npm run build

# Production image
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
# copia desde builder
COPY --from=builder /app ./

# Exponer puerto que usa next start (3000 por defecto)
EXPOSE 3000

# Si usas "next start" (asegúrate package.json tenga "start": "next start -p 3000")
CMD ["sh", "-c", "npm run start"]


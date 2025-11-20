# Stage 1: build
FROM node:20-bullseye AS build-stage

WORKDIR /app

# Copia solo le deps per caching
COPY package*.json ./
RUN npm install --omit=optional

# Copia il resto del codice
COPY . .

# Stage 2: serve (vite dev per sviluppo)
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

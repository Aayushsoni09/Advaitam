# ---- Base image ----
FROM node:18-alpine

# ---- Set working directory ----
WORKDIR /app

# ---- Install dependencies first (layer caching) ----
COPY package*.json ./
RUN npm ci --only=production

# ---- Copy source code ----
COPY . .

# ---- Expose app port ----
EXPOSE 5000

# ---- Run the app ----
CMD ["node", "server.js"]

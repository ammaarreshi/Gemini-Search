FROM node:20-alpine as builder

WORKDIR /app

# 复制项目文件
COPY package*.json ./
COPY tsconfig.json ./
COPY vite.config.ts ./
COPY postcss.config.js ./
COPY tailwind.config.ts ./
COPY drizzle.config.ts ./
COPY theme.json ./
COPY client/ ./client/
COPY server/ ./server/
COPY db/ ./db/

# 安装依赖并构建
RUN npm ci
RUN npm run build

# 生产环境
FROM node:20-alpine

WORKDIR /app

# 复制构建产物和必要文件
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/db ./db

# 安装生产环境依赖，并确保包含 vite
RUN npm ci && npm install vite

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=7788

# 暴露端口
EXPOSE 7788

# 启动应用
CMD ["npm", "start"] 
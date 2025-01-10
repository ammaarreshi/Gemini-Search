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

# 只安装生产依赖
RUN npm ci --omit=dev

# 设置环境变量
ENV NODE_ENV=production

# 检查必需的环境变量
ARG GOOGLE_API_KEY
ENV GOOGLE_API_KEY=$GOOGLE_API_KEY
RUN if [ -z "$GOOGLE_API_KEY" ] ; then echo "GOOGLE_API_KEY is required" && exit 1; fi

# 设置默认的 BASE_URL
ENV BASE_URL=https://generativelanguage.googleapis.com

# 暴露端口（使用 ARG 指令允许在构建时传入端口值）
ARG PORT=3000
ENV PORT=$PORT
EXPOSE $PORT

# 启动应用
CMD ["npm", "start"] 
# 使用nodejs的缩小版作为镜像,因为需要npm安装依赖包和执行命令
FROM node:alpine as builder

# 设置工作目为/app
WORKDIR /app

# 将package.json复制到根目录
COPY package.json .

# 设置node-sass的下载源
RUN npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/

# 设置npm的源
RUN npm install --registry=http://registry.npm.taobao.org

# 复制所有源代码到根目录
COPY . .

# 执行npm run build 进行编译
RUN npm run build

# 使用nginx缩小版作为基础镜像
FROM nginx:alpine

# 将构建的dist目录复制到/usr/share/nginx/html 此目录后进行nginx代理,启动nginx后可以访问
COPY --from=builder /app/dist /usr/share/nginx/html
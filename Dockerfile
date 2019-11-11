# Get node to build
FROM node:12.13.0-alpine as builder

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package.json yarn.lock ./
RUN yarn install
COPY . .

# Build vue
RUN [ "yarn", "build" ]

# Get nginx to serve
FROM nginxinc/nginx-unprivileged:stable

# Copy dist to default location for nginxinc/nginx-unprivileged
COPY --from=builder /app/dist /usr/share/nginx/html

# Open port
EXPOSE 8080

#Start
CMD ["nginx", "-g", "daemon off;"]


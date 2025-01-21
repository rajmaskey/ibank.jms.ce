# Step 1: Build the Gatsby site
FROM node:18 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Gatsby site
RUN npm run build

# Step 2: Serve the Gatsby site using a web server
FROM nginx:alpine AS production

# Copy the built Gatsby files from the builder stage
COPY --from=builder /app/public /usr/share/nginx/html

# Copy custom nginx configuration (optional, but recommended for SPA handling)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

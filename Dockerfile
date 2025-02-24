# Use a multi-stage build to optimize the final image size

# --- Server Stage ---
FROM node:18-alpine AS server-build

WORKDIR /app/server

# Copy package.json and package-lock.json
COPY server/package*.json ./

# Install server dependencies
RUN npm install

# Copy server source code
COPY server/. ./

# --- Client Stage ---
FROM nginx:alpine AS client-build

WORKDIR /usr/share/nginx/html

# Copy client files
COPY client/index.html ./
COPY client/script.js ./
COPY client/models ./models

# --- Final Stage ---
FROM nginx:alpine

# Copy built client files from client-build stage
COPY --from=client-build /usr/share/nginx/html /usr/share/nginx/html

# Copy built server from server-build stage
COPY --from=server-build /app/server /app/server

# Copy the entrypoint script
FROM ...

COPY entrypoint.sh /  # Copies the script to /entrypoint.sh inside the container
RUN chmod +x /entrypoint.sh # adds execute permissions
CMD ["/entrypoint.sh"]

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose port 80 for the client
EXPOSE 80

# Use environment variables for database configuration
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=password
ENV MYSQL_DATABASE=mydb

# Start the server and Nginx
CMD ["/entrypoint.sh"]


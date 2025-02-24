#!/bin/bash
# Substitute environment variables into server.js
envsubst < /app/server/server.js > /app/server/server.js.tmp && mv /app/server/server.js.tmp /app/server/server.js

# Start the server and Nginx
node /app/server/server.js & nginx -g 'daemon off;'
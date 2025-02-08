FROM jwilder/nginx-proxy:latest

RUN apt-get update && apt-get install -y tcpdump

COPY nginx.conf /etc/nginx/nginx.conf
# Copy cert
COPY server.crt /etc/nginx/ssl/server.crt
# Copy key
COPY server.key /etc/nginx/ssl/server.key

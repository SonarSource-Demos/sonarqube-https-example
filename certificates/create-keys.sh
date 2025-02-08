#!/bin/bash

# This script creates a self-signed certificate for the proxy server
# All steps came from this tutorial: https://www.youtube.com/watch?v=VH4gXcvkmOY

# Path to the OpenSSL configuration file
OPENSSL_CONF="openssl.cnf"

# Set the passphrase
PASSPHRASE="changeit" # Change this to your own passphrase

# Create CA Private Key with AES256 encryption
openssl genrsa -aes256 -passout "pass:${PASSPHRASE}" -out ca-key.pem 4096 && \

# Create CA Certificate
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -config "${OPENSSL_CONF}" -passin "pass:${PASSPHRASE}" -passout "pass:${PASSPHRASE}" && \

# Create Private Key for Certificate
openssl genrsa -passout "pass:${PASSPHRASE}" -out cert-key.pem 4096 && \

# Create a Certificate Signing Request
openssl req -new -sha256 -key cert-key.pem -out cert.csr -config "${OPENSSL_CONF}" -passin "pass:${PASSPHRASE}" && \

# Create a Certificate
openssl x509 -req -days 365 -sha256 -in cert.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile "${OPENSSL_CONF}" -passin "pass:${PASSPHRASE}" && \

# Create the chain file
cat cert.pem > fullchain.pem && \
cat ca.pem >> fullchain.pem && \

# rename
cp fullchain.pem server.crt && \
cp cert-key.pem server.key && \

# delete intermediate files
rm -f ca-key.pem && \
rm -f ca.pem && \
rm -f ca.srl && \
rm -f cert-key.pem && \
rm -f cert.csr && \
rm -f cert.pem && \
rm -f fullchain.pem && \

# print success message
echo "Success! Public Self-Signed Certification is 'server.crt' and Private Key is 'server.key'"
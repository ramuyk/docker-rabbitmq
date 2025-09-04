#!/bin/bash
set -e

# Certificate directories
HOST_CERT_DIR="/host/certificates"
RABBITMQ_CERT_DIR="/etc/rabbitmq/ssl"

# Create RabbitMQ SSL directory if it doesn't exist
mkdir -p "$RABBITMQ_CERT_DIR"

# Check if certificates exist in the host volume
if [ -f "$HOST_CERT_DIR/server.pem" ] && [ -f "$HOST_CERT_DIR/ca.crt" ] && [ -f "$HOST_CERT_DIR/server.crt" ] && [ -f "$HOST_CERT_DIR/server.key" ]; then
    echo "Found existing SSL certificates in $HOST_CERT_DIR, copying to RabbitMQ directory..."
    cp "$HOST_CERT_DIR"/* "$RABBITMQ_CERT_DIR"/
else
    echo "No existing SSL certificates found in $HOST_CERT_DIR, generating new ones..."
    
    # Generate new certificates directly in the host volume directory
    mkdir -p "$HOST_CERT_DIR"
    
    # Generate CA key
    openssl genrsa -out "$HOST_CERT_DIR/ca.key" 2048
    
    # Generate CA certificate
    openssl req -new -x509 -key "$HOST_CERT_DIR/ca.key" -out "$HOST_CERT_DIR/ca.crt" -days 36500 \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=RabbitMQ-CA"
    
    # Generate server key
    openssl genrsa -out "$HOST_CERT_DIR/server.key" 2048
    
    # Generate server certificate request
    openssl req -new -key "$HOST_CERT_DIR/server.key" -out "$HOST_CERT_DIR/server.csr" \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    # Generate server certificate signed by CA
    openssl x509 -req -in "$HOST_CERT_DIR/server.csr" -CA "$HOST_CERT_DIR/ca.crt" -CAkey "$HOST_CERT_DIR/ca.key" \
        -out "$HOST_CERT_DIR/server.crt" -days 36500 -CAcreateserial
    
    # Create PEM file with certificate and key
    cat "$HOST_CERT_DIR/server.crt" "$HOST_CERT_DIR/server.key" > "$HOST_CERT_DIR/server.pem"
    
    # Copy certificates to RabbitMQ directory
    cp "$HOST_CERT_DIR"/* "$RABBITMQ_CERT_DIR"/
    
    echo "SSL certificates generated successfully and saved to $HOST_CERT_DIR"
fi

# Set proper permissions for RabbitMQ
chmod 600 "$RABBITMQ_CERT_DIR"/*
chown -R rabbitmq:rabbitmq "$RABBITMQ_CERT_DIR"

# Enable plugins
rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_web_mqtt rabbitmq_management

# Start RabbitMQ
exec rabbitmq-server

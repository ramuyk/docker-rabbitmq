FROM rabbitmq:3.13.1-management

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# Copy RabbitMQ SSL configuration
COPY conf/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

# Copy and set up custom entrypoint
COPY scripts/docker-entrypoint-ssl.sh /usr/local/bin/docker-entrypoint-ssl.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-ssl.sh

# Use our custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-ssl.sh"]
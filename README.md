# Introduction

This repository provides a `docker-compose.yml` ready-to-use Docker configuration to simplify the deployment of the official RabbitMQ Docker container with the MQTT plugin enabled. For comprehensive details about additional configurations, please refer to the [RabbitMQ official Docker Hub installation guide](https://hub.docker.com/_/rabbitmq).

## Repository Contents

This repository includes:

- **Docker Compose File**: A `docker-compose.yml` file that configures the RabbitMQ Docker container with MQTT. Highlights of this setup include:
  - **Persistent Data Storage**: Configures a volume:
    - `rabbitmq_data` at `/var/lib/rabbitmq` for storing RabbitMQ data, ensuring that your configurations and data are preserved when the container is restarted.
  - **Plugin Activation**: Automatically enables the MQTT plugin on startup.
  - **Service Ports**: Exposes service ports for AMQP, MQTT, and the management interface, initially bound to `127.0.0.1`.

## Getting Started

### Important Preliminary Steps

Before starting the quick setup, please note the following adjustments:

1. **Important Note on Port Mapping**: The `docker-compose.yml` file contains port mappings to `127.0.0.1`, limiting access to the localhost only. To make the service accessible from other machines or publicly, change the IP address in the port mapping. For instance, use `0.0.0.0` to bind to all network interfaces, updating the ports line to `- "0.0.0.0:5672:5672"` for broader network access.

2. **Environment Configuration**:
   Modify the default user and password as needed. It's important to change the default credentials (`RABBITMQ_DEFAULT_USER` and `RABBITMQ_DEFAULT_PASS`) for production environments to ensure security.

### Quick Setup

1. **Clone the Repository**:
   Clone this repository to your local machine using the following Git command:
   ```bash
   git clone https://github.com/ramuyk/docker-rabbitmq.git
   cd docker-rabbitmq
   ```

2. **Start RabbitMQ**:
   Navigate to the directory containing your `docker-compose.yml` and run:
   ```bash
   docker-compose up -d
   ```

3. **Access RabbitMQ Management Interface**:
   Open a web browser and navigate to `http://localhost:15672` to access the RabbitMQ management interface. The pre-configured admin credentials are:
   - **Username**: rabbitmq
   - **Password**: rabbitmq

   It is recommended to change these credentials immediately after your first login for security reasons.

4. **Service Accessibility**:
   Along with the web management interface, the RabbitMQ services for AMQP and MQTT are available on their respective ports:
   - **AMQP**: Accessible at `localhost:5672` – This is the standard messaging protocol used by RabbitMQ for queueing messages.
   - **MQTT**: Accessible at `localhost:1883` – This is the IoT protocol enabled by the MQTT plugin for lightweight publish/subscribe messaging.

   Ensure that the correct port mappings are used if accessing these services from remote machines or different network configurations.

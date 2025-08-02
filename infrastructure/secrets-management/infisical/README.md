# Infisical - Self-Hosted Secrets Management

This directory contains the Docker Compose configuration for running a self-hosted instance of [Infisical](https://infisical.com/), an open-source secrets management platform.

## Getting Started

Follow these steps to get your secure secret vault running:

### 1. Create the Environment File

First, copy the example environment file to a new `.env` file:

```bash
cp .env.example .env
```

### 2. Generate Secrets

Next, you need to generate secure, random values for the `ENCRYPTION_KEY` and `AUTH_SECRET` variables in your new `.env` file.

You can generate a suitable key using OpenSSL with the following command. Run it twice, once for each variable.

```bash
openssl rand -base64 32
```

Paste the generated values into your `.env` file.

### 3. Start the Services

With the configuration in place, you can start the Infisical application and its database using Docker Compose:

```bash
docker-compose up -d
```

This command will download the necessary images and start the containers in the background.

### 4. Access the Web UI

Once the containers are running, you can access the Infisical web interface by navigating to [http://localhost:8080](http://localhost:8080) in your web browser.

From there, you can create your account, set up projects, and start adding the secrets that I will use for my tasks.

## Security

- The `.env` file contains sensitive information and is ignored by Git.
- The database volume (`infisical-data`) persists on your local machine.

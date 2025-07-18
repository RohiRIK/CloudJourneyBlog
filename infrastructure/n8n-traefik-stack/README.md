# n8n with Traefik and Let's Encrypt

## Introduction

[n8n](https://n8n.io/) is a powerful, open-source workflow automation tool that allows you to connect various services and automate tasks without writing code. Think of it as an open-source alternative to services like Zapier or Make (formerly Integromat).

This project provides a production-ready Docker Compose setup for securely deploying n8n with:

- **Traefik** as a reverse proxy to handle routing and SSL termination
- **Let's Encrypt** for automatic SSL certificate generation and renewal
- **PostgreSQL** for reliable data storage
- **Cloudflare DNS validation** for secure certificate issuance even on non-public servers

### Why This Setup?

- **Security**: Properly configured with HTTPS, authentication, and secure defaults
- **Reliability**: Uses PostgreSQL instead of SQLite for better performance and data integrity
- **Maintainability**: All configuration in a single docker-compose.yml with environment variables
- **Automatic Updates**: Includes instructions for keeping everything up to date

## Prerequisites

1. Docker and Docker Compose installed
2. A domain name you control
3. DNS records pointing to your server's IP address
4. Cloudflare account (for DNS challenge)

## Setup Instructions

1. Clone the CloudJourneyBlog repository:
   ```bash
   git clone git@github.com:RohiRIK/CloudJourneyBlog.git
   cd CloudJourneyBlog/infrastructure/n8n-traefik-stack
   ```

2. Copy the example environment file and update it with your values:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. Generate a password hash for basic authentication:
   ```bash
   echo $(htpasswd -nb <username> <password>) | sed -e s/\\$/\\$\$/g
   ```
   Update the `N8N_BASIC_AUTH_HASH` in your `.env` file with the output.

4. Start the services:
   ```bash
   docker-compose up -d
   ```

5. Access n8n at `https://n8n.your-domain.com` (replace with your domain)

## Configuration

### Environment Variables

Here are the key environment variables you need to configure in your `.env` file:

#### Domain and TLS Configuration
- `TRAEFIK_DOMAIN`: Your base domain (e.g., example.com)
- `N8N_SUBDOMAIN`: Subdomain for n8n (e.g., n8n)
- `TRAEFIK_ACME_EMAIL`: Email for Let's Encrypt notifications

#### Cloudflare Configuration
- `CLOUDFLARE_DNS_API_TOKEN`: Cloudflare API token with DNS edit permissions
  - Create this token in your Cloudflare account dashboard
  - Required permissions: Zone > DNS > Edit
  - For enhanced security, restrict the token to specific zones (domains)

#### Database Configuration
- `POSTGRES_USER`: PostgreSQL username (default: n8n)
- `POSTGRES_PASSWORD`: PostgreSQL password (generate a strong, unique password)
- `POSTGRES_DB`: PostgreSQL database name (default: n8n)

#### n8n Configuration
- `N8N_BASIC_AUTH_USER`: Username for accessing n8n web interface
- `N8N_BASIC_AUTH_PASSWORD`: Password for accessing n8n web interface
- `N8N_ENCRYPTION_KEY`: Encryption key for sensitive data (generate a random string at least 32 chars long)

### Docker Compose Configuration

The `docker-compose.yml` file includes three main services:

1. **traefik**: The reverse proxy that handles routing and TLS certificates
   - Configured with automatic certificate generation through Let's Encrypt
   - Uses Cloudflare DNS challenge for verification
   - Exposes ports 80 and 443

2. **postgres**: PostgreSQL database for storing n8n data
   - Uses a Docker volume for persistent storage
   - Configured with the credentials specified in your `.env` file

3. **n8n**: The main n8n application
   - Connected to the PostgreSQL database
   - Protected with basic authentication
   - Configured with your environment-specific variables

## Security Notes

1. Change all default passwords in the `.env` file
2. Use strong, unique passwords
3. Keep your server and containers updated
4. Regularly backup your data

## Updating the Stack

To update your n8n stack to the latest versions:

1. Pull the latest changes from the repository:
   ```bash
   git pull
   ```

2. Update the Docker images:
   ```bash
   docker-compose pull
   ```

3. Restart the services with the updated images:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

> **Note**: Always check the [n8n changelog](https://docs.n8n.io/release-notes/) before updating to be aware of any breaking changes.

## Backup and Restore

### Creating Backups

To backup your n8n data:

1. PostgreSQL database (recommended to run regularly via cron):
   ```bash
   docker exec -t postgres pg_dump -U n8n n8n > n8n_backup_$(date +%Y%m%d).sql
   ```

2. n8n workflows and credentials:
   ```bash
   # Export workflows
   docker exec -t n8n n8n export:workflow --all --output=/backup/workflows_$(date +%Y%m%d).json
   
   # Export credentials (encrypted)
   docker exec -t n8n n8n export:credentials --output=/backup/credentials_$(date +%Y%m%d).json
   ```

3. Docker volumes:
   The n8n data is stored in Docker volumes named `n8n_data` and `postgres_data`.

### Restoring from Backup

1. To restore the PostgreSQL database:
   ```bash
   cat n8n_backup_YYYYMMDD.sql | docker exec -i postgres psql -U n8n
   ```

2. To restore workflows:
   ```bash
   docker exec -i n8n n8n import:workflow --input=/backup/workflows_YYYYMMDD.json
   ```

## Troubleshooting

### Common Issues

1. **Certificate Issues**
   - Ensure your Cloudflare API token has the correct permissions
   - Check Traefik logs: `docker-compose logs traefik`
   - Verify your DNS records are properly configured in Cloudflare

2. **n8n Can't Connect to Database**
   - Check PostgreSQL logs: `docker-compose logs postgres`
   - Ensure the database credentials in `.env` match what's in the docker-compose.yml
   - Try restarting the services: `docker-compose restart`

3. **Webhook Functionality Not Working**
   - Ensure your domain is publicly accessible
   - Check that the correct ports (80/443) are forwarded if behind a router/firewall
   - Verify the `N8N_WEBHOOK_URL` is correctly set in your `.env` file

4. **Performance Issues**
   - Increase the resources allocated to Docker if running on a local machine
   - Consider increasing PostgreSQL shared memory limits for larger workflows

### Getting Help

- Review the [n8n documentation](https://docs.n8n.io/)
- Check the [n8n community forum](https://community.n8n.io/)
- Open an issue on the GitHub repository if you believe there's a problem with this setup

## License

MIT

# n8n with Traefik and Let's Encrypt

This repository contains a Docker Compose setup for running n8n securely with Traefik as a reverse proxy and Let's Encrypt for TLS certificates.

## Prerequisites

1. Docker and Docker Compose installed
2. A domain name you control
3. DNS records pointing to your server's IP address
4. Cloudflare account (for DNS challenge)

## Setup Instructions

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd n8n-traefik-stack
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

- `TRAEFIK_DOMAIN`: Your base domain (e.g., example.com)
- `N8N_SUBDOMAIN`: Subdomain for n8n (e.g., n8n)
- `TRAEFIK_ACME_EMAIL`: Email for Let's Encrypt
- `CLOUDFLARE_DNS_API_TOKEN`: Cloudflare API token with DNS edit permissions
- `POSTGRES_*`: PostgreSQL database configuration
- `N8N_*`: n8n specific configuration

## Security Notes

1. Change all default passwords in the `.env` file
2. Use strong, unique passwords
3. Keep your server and containers updated
4. Regularly backup your data

## Backup and Restore

To backup your n8n data:

1. PostgreSQL database:
   ```bash
   docker exec -t postgres pg_dump -U n8n n8n > n8n_backup_$(date +%Y%m%d).sql
   ```

2. n8n data:
   The n8n data is stored in a Docker volume named `n8n_data`.

## License

MIT

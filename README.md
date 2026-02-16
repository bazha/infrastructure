# Microservices Infrastructure

## Overview

Docker Compose infrastructure for microservices application using gRPC, PostgreSQL, and RabbitMQ.

**Stack:** PostgreSQL 17, RabbitMQ 3, gRPC/Protocol Buffers, Node.js/NestJS, JWT authentication

## Services

**Infrastructure:** PostgreSQL, RabbitMQ  
**Application:** API Gateway (port 3000), Auth, Customers, Orders, Products

## Prerequisites

- Docker Desktop or Docker Engine
- Docker Compose V2+

## Setup

### 1. Create `.env` file

```env
# Database
DB_PORT=5432
DB_PASSWORD=your_secure_password
DB_USER=postgres
DB_API=api_db
DB_CUST=customers_db

# RabbitMQ
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_REFRESH_SECRET=your_jwt_refresh_secret_key
```

### 2. Start Services

```bash
docker compose up -d
docker compose ps  # Verify status
```

### 3. Access Points

- API Gateway: http://localhost:3000
- RabbitMQ UI: http://localhost:15672 (guest/guest)
- PostgreSQL: localhost:5432

## Common Commands

```bash
# Start/Stop
docker compose up -d
docker compose down
docker compose down -v  # Delete all data

# Logs
docker compose logs -f
docker compose logs -f <service-name>

# Rebuild
docker compose up -d --build <service-name>

# Database shell
docker compose exec postgres psql -U postgres
```

## Project Files

```
infrastructure/
├── docker-compose.yml  # Service orchestration
├── init-db.sh         # Database setup
├── .env               # Configuration
└── protos/            # gRPC contracts
```

## Database

**Pattern:** Database-per-service  
**Created on startup:** `api_db`, `customers_db` (via `init-db.sh`)  
**Migrations:** Run automatically in customers service

## Troubleshooting

**Services won't start:**
- Verify `.env` exists with all required variables
- Check ports available: 3000, 5432, 5672, 15672
- Run `docker compose ps` to check health

**Database issues:**
- Make executable: `chmod +x init-db.sh`
- Check logs: `docker compose logs postgres`

**RabbitMQ issues:**
- Check health: `docker compose logs rabbitmq`

## Development

- Proto files mounted from `protos/` to all services
- API Gateway has hot reload via watch mode
- Services wait for health checks before starting

## Production Notes

⚠️ **Before production deployment:**
- Change default passwords and rotate secrets
- Enable SSL/TLS and implement proper secrets management

## Related Services

Expects sibling directories: `../api-gateway`, `../auth`, `../customers`, `../orders`, `../products`
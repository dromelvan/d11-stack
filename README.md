# d11-stack
This stack sets up a PostgreSQL database, ActiveMQ Artemis broker, a Spring Boot backend, NGINX web server, and a PostgreSQL backup container using Docker Compose.

## Services

### 1. `postgres`
- **Image**: `postgres:17.4`
- **Ports**: `5432:5432`
- **Environment Variables**:
  - `POSTGRES_PASSWORD`
  - `D11DBUSER_PASSWORD`
  - `TZ=Europe/Helsinki`
- **Volumes**:
  - `postgres_data`: PostgreSQL data
  - `./postgres`: init_database.sh creates the database user and the d11 prod and development databases

### 2. `pg-backup`
- **Custom Docker Image**: Based on `debian:bullseye-slim`
- **Functionality**: Dumps backups of the `d11` database daily at 4:00 AM
- **Volumes**:
  - `./pg-backup/backups`: Stores `.sql` files sorted into subdirectories by year and month
- **Environment**:
  - Uses `PGPASSWORD` environment variable passed from Compose
- **Cron Job**: Runs `backup.sh` daily at 04:00

### 3. `artemis`
- **Image**: `apache/activemq-artemis:2.40.0`
- **Functionality**: Provides JMS queues for the D11 application
- **Ports**:
  - `61616:61616`
  - `8161:8161`
- **Authentication**: Uses `ARTEMIS_USER` and `ARTEMIS_PASSWORD`

### 4. `d11-boot`
- **Spring Boot REST API**
- **Ports**:
  - `8080:8080`
  - `8443:8443`
- **Environment Variables**:
  - `SPRING_PROFILES_ACTIVE=production`
  - `JASYPT_ENCRYPTOR_PASSWORD`
- **Depends on**: `postgres`, `artemis`

### 5. `nginx`
- **Functionality**: Reverse proxy that forwards /api calls to d11-boot
- **Image**: `nginx:1.27.4`
- **Ports**: `80:80`
- **Volumes**:
  - `./public`: Static files
  - `./nginx/default.conf`: NGINX configuration

## Networks

All services share the same Docker network: `d11`.

## Volumes

- `postgres_data`: PostgreSQL database persistence
- `artemis_data`: Artemis broker persistence

## Backups

Backups are performed by the `pg-backup` service using `pg_dump` and stored in `/backups/YYYY/MM/` format. The backup script is triggered via cron, and environment variables are persisted in `/etc/environment` to ensure access for the cron job.

## Usage

Provide the following variables in .env:
- **COMPOSE_PROJECT_NAME**: Stack name
- **FILES_PATH**: Base directory for d11-boot container file storage
- **LOG_PATH**: d11-boot container log directory

Use the included scripts:
- **build_images.sh**: Builds the d11-boot and pg-backup images
- **run_stack.sh**: Provide the stack password to start all

Manual commands:
- **docker exec pg-backup /scripts/backup.sh**: Manually trigger a backup
- **docker exec pg-backup tail -n 50 /var/log/cron.log**: Check pg-backup cron log for errors. "No such file" means there hasn't been any errors.
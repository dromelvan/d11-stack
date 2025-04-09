FROM debian:bullseye-slim

# Install curl and gnupg first
RUN apt-get update && apt-get install -y curl gnupg lsb-release

# Add PostgreSQL APT repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install postgresql-client-17 and cron
RUN apt-get update && \
    apt-get install -y postgresql-client-17 cron && \
    mkdir -p /scripts /backups && \
    apt-get clean

# Copy backup script and crontab
COPY backup.sh /scripts/backup.sh
COPY crontab.txt /etc/cron.d/pg-cron

RUN chmod +x /scripts/backup.sh && \
    chmod 0644 /etc/cron.d/pg-cron && \
    crontab /etc/cron.d/pg-cron

# env >> /etc/environment dumps environment variables from the Docker container to /etc/environment
# and cron has access to /etc/environment so this gives cron access to passwords etc
ENTRYPOINT ["/bin/bash", "-c", "env >> /etc/environment && cron -f"]


#!/bin/bash
set -e

echo "Setting up cron job for S3 sync..."

# Create the target directory
mkdir -p /usr/local/tomcat/content/thredds/public/austemp

# Setup cron job (runs every hour at minute 0)
# Adjust the schedule as needed: https://crontab.guru/
# Set PATH so cron can find aws CLI
(echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"; \
 echo "*/30 * * * * /usr/local/bin/sync-s3.sh >> /var/log/s3-sync.log 2>&1") | crontab -

# Start cron daemon in background
cron

echo "Cron daemon started. S3 sync will run every hour."

# Run initial sync
/usr/local/bin/sync-s3.sh >> /var/log/s3-sync.log 2>&1 &

# Execute the original command (passed as arguments to this script)
# This preserves the original ENTRYPOINT and CMD from the base image
exec "$@"

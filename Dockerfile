# Use the official Unidata THREDDS base image
FROM unidata/thredds-docker:5.6

# Set build-time environment variable for convenience (already defined in base image, but safe to reference)
ENV CATALINA_HOME=/usr/local/tomcat

# Install AWS CLI and cron
RUN apt-get update && \
    apt-get install -y cron curl

RUN <<EOF
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
EOF

# Copy your local config files into the THREDDS content directory
COPY config/threddsConfig.xml ${CATALINA_HOME}/content/thredds/threddsConfig.xml
COPY config/catalog.xml ${CATALINA_HOME}/content/thredds/catalog.xml
COPY config/wmsConfig.xml ${CATALINA_HOME}/content/thredds/wmsConfig.xml

# Copy cron scripts
COPY scripts/sync-s3.sh /usr/local/bin/sync-s3.sh
COPY scripts/start-with-cron.sh /usr/local/bin/start-with-cron.sh

# Make scripts executable and create log file
RUN chmod +x /usr/local/bin/sync-s3.sh /usr/local/bin/start-with-cron.sh && \
    touch /var/log/s3-sync.log

# Wrap the original entrypoint - this preserves the base image's CMD
ENTRYPOINT ["/usr/local/bin/start-with-cron.sh"]

# Re-declare the original CMD from the base image (catalina.sh run)
CMD ["catalina.sh", "run"]
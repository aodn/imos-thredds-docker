#!/bin/bash
# Sync latest file from public S3 to local directory
# Adjust the S3 path and file patterns as needed

S3_PATH="s3://imos-data/IMOS/SRS/AusTemp/ssta/2025/"
LOCAL_PATH="/usr/local/tomcat/content/thredds/public/austemp"

# Create directory if it doesn't exist
mkdir -p "$LOCAL_PATH"

# Sync from S3 (using --no-sign-request for public buckets)
# Adjust --include/--exclude patterns as needed
aws s3 sync "$S3_PATH" "$LOCAL_PATH" \
    --no-sign-request \
    --region ap-southeast-2 \
    --exclude "*" \
    --include "2025102*.nc"

echo "$(date): S3 sync completed"

#!/bin/bash

# Get timestamp
now=$(date +"%Y-%m-%d-%H-%M-%S")

# Create a gzip compressed tarball with the volume(s)
tar czf $BACKUP_NAME.$now.tar.gz $PATHS_TO_BACKUP

# Create bucket, if it doesn't already exist
aws mkdir $S3_BUCKET_NAME

# Upload the backup to S3 with timestamp
aws put $S3_BUCKET_NAME/$BACKUP_NAME.$now.tar.gz $BACKUP_NAME.$now.tar.gz
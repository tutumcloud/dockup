#!/bin/bash

# Get timestamp
now=$(date +"%Y-%m-%d-%H-%M-%S")

# Create a gzip compressed tarball with the volume(s)
tar czf $BACKUP_NAME.$now.tar.gz $PATHS_TO_BACKUP

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ]; 
then
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 cp $BACKUP_NAME.$now.tar.gz s3://$S3_BUCKET_NAME/$BACKUP_NAME.$now.tar.gz

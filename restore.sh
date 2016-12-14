#!/bin/bash

# Find last backup file
: ${LAST_BACKUP:=$(aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}

# Download backup from S3
aws s3 cp $LAST_BACKUP s3://$S3_BUCKET_NAME/$LAST_BACKUP

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION

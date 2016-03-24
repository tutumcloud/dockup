#!/bin/bash

if [ ! -n "${LAST_BACKUP}" ]; then
  # Find last backup file
  : ${LAST_BACKUP:=$(aws s3 --region $AWS_DEFAULT_REGION ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}
fi

# Download backup from S3
aws s3 --region $AWS_DEFAULT_REGION cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP || (echo "Failed to download tarball from S3"; exit)

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION || exit

# If a post extraction command is defined, run it
if [ -n "$AFTER_RESTORE_CMD" ]; then
	eval "$AFTER_RESTORE_CMD" || exit
fi

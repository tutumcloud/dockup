#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

# If a pre-backup command is defined, run it before creating the tarball
if [ -n "$BEFORE_BACKUP_CMD" ]; then
	eval "$BEFORE_BACKUP_CMD" || exit
fi

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 --region $AWS_DEFAULT_REGION ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  aws s3 --region $AWS_DEFAULT_REGION mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball

# Clean up
rm $tarball

# If a post-backup command is defined (eg: for cleanup)
if [ -n "$AFTER_BACKUP_CMD" ]; then
	eval "$AFTER_BACKUP_CMD"
fi
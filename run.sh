#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh

  if [ -n "$CRON_TIME" ]; then
    echo "${CRON_TIME} /backup.sh >> /dockup.log 2>&1" > /crontab.conf
    crontab  /crontab.conf
    echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"
    exec cron -f
  fi

fi
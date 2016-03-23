#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  if [ -n "$CRON_TIME" ]; then
    env | grep -v 'affinity:container' | sed -e 's/^\([^=]*\)=\(.*\)/export \1="\2"/' > /env.conf # Save current environment
    echo "${CRON_TIME} . /env.conf && /backup.sh >> /dockup.log 2>&1" > /crontab.conf
    crontab  /crontab.conf
    echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"
    exec cron -f
  else
    ./backup.sh
  fi
fi
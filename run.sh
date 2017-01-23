#!/bin/bash

touch /mongo_backup.log
tail -F /mongo_backup.log &

if [ -n "${INIT_BACKUP}" ]; then
    echo "=> Create a backup on the startup"
    /backup.sh
fi

echo "=> Preparing env vars for backup script running in cron"
printenv | sed 's/^\(.*\)\=\(.*\)$/export \1\="\2"/g' > /root/cron_env.sh

echo "=> Preparing crontab"
echo "${CRON_TIME} . /root/cron_env.sh; /backup.sh >> /mongo_backup.log 2>&1" > /crontab.conf
crontab  /crontab.conf

echo "=> Running cron job"
exec cron -f

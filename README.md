# Mongodb Backup
Simple MongoDB backup that run scheduled backups of mongodb and upload it to S3

Fork of https://github.com/tutumcloud/mongodb-backup simplified, and with S3 parts from https://bitbucket.org/taccaci/mongodb-sync

## Usage:
At the moment it does not support username, password or selection of specific db. Use https://bitbucket.org/taccaci/mongodb-sync if all that is needed

    docker run -d \
        --env MONGODB_HOST=mongodb.host \
        --env MONGODB_PORT=27017 \
        --volume host.folder:/backup
        mongodb-backup

## Parameters through env
    MONGODB_HOST           the host/ip of your mongodb database
    MONGODB_PORT           the port number of your mongodb database
    EXTRA_OPTS             the extra options to pass to mongodump command
    CRON_TIME              the interval of cron job to run mongodump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS            the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit, by default
    INIT_BACKUP            if set, create a backup when the container launched
    AWS_ACCESS_KEY_ID	your aws id
    AWS_SECRET_ACCESS_KEY  your aws key
    S3_BUCKET              Bucket in S3
    S3_BACKUP              if set, upload backup to S3

## Restore from a backup
See the list of backups, you can run:

    docker exec mongodb-backup ls /backup

To restore database from a certain backup, simply run:

    docker exec mongodb-backup /restore.sh /backup/name-of-backup

NOTE: Restore will not overwrite the existing database, but just add the backup

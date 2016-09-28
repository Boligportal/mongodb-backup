#!/bin/bash
MAX_BACKUPS=${MAX_BACKUPS}
BACKUP_NAME=$(date +%Y.%m.%d.%H%M%S)
BACKUP_CMD="mongodump --out /backup/${BACKUP_NAME} --host ${MONGODB_HOST} --port ${MONGODB_PORT} ${EXTRA_OPTS}"

echo "=> Backup started"
if ${BACKUP_CMD} ;then
    echo "   Backup succeeded"

		if [[ -n "$S3_BACKUP" ]]; then
			echo "   Archiving and backing up dump to S3"

			echo "   Creating archive at /backup/${BACKUP_NAME}.tgz"
			tar czf "/backup/${BACKUP_NAME}.tgz" "/backup/${BACKUP_NAME}"

			echo "   Copying to S3"
			aws s3 cp "/backup/${BACKUP_NAME}.tgz" s3://$S3_BUCKET/$S3_PATH/${BACKUP_NAME}.tgz

			if [ $? == 0 ]; then
					rm "/backup/${BACKUP_NAME}.tgz"
			else
					>&2 echo "couldn't transfer /backup/${BACKUP_NAME}.tgz to S3"
			fi
		fi
else
    echo "   Backup failed"
    rm -rf /backup/${BACKUP_NAME}
fi
if [ -n "${MAX_BACKUPS}" ]; then
    while [ $(ls /backup -N1 | wc -l) -gt ${MAX_BACKUPS} ];
    do
        BACKUP_TO_BE_DELETED=$(ls /backup -N1 | sort | head -n 1)
        echo "   Deleting backup ${BACKUP_TO_BE_DELETED}"
        rm -rf /backup/${BACKUP_TO_BE_DELETED}
    done
fi
echo "=> Backup done"

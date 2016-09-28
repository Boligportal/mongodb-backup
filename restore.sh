#!/bin/bash
echo "=> Restore database from $1"
if mongorestore --host ${MONGODB_HOST} --port ${MONGODB_PORT} $1; then
    echo "   Restore succeeded"
else
    echo "   Restore failed"
fi
echo "=> Done"

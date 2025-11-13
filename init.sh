#!/bin/bash
set -e 

echo "Init-Script started"
#rm /data/server.properties

ls /data
if [ -f /data/server.properties ]; then
    echo "deleting server.properties"
    rm /data/server.properties
else
    echo "server.properties does not yet exist."
fi
ls /data

#rm -f /data/server.properties
echo "Datei gelöscht!"

exec /start

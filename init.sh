#!/bin/bash
if [ -f /data/server.properties ]; then
    rm /data/server.properties
fi

exec /start

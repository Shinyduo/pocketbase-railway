#!/bin/sh
set -e

# Start PocketBase in the background
/usr/local/bin/pocketbase serve --http=0.0.0.0:$PORT --dir=/root/pocketbase &
PB_PID=$!

# Give PocketBase a few seconds to come up
sleep 2

# If superuser details available, create the superuser
if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASS" ]; then
    /usr/local/bin/pocketbase superuser upsert "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASS"
fi

# Bring PocketBase process to the foreground
wait $PB_PID

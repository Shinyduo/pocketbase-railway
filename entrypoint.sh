#!/bin/sh
set -e

# Data directory - must be the volume mount path, and must be identical for
# every pocketbase subcommand or they operate on different databases.
PB_DATA_DIR="${PB_DATA_DIR:-/root/pocketbase}"

# Start PocketBase in the background
/usr/local/bin/pocketbase serve --http=0.0.0.0:${PORT:-8080} --dir="$PB_DATA_DIR" &
PB_PID=$!

# Give PocketBase a few seconds to come up
sleep 2

# If superuser details available, create the superuser
if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASS" ]; then
    /usr/local/bin/pocketbase superuser upsert "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASS" --dir="$PB_DATA_DIR"
fi

# Bring PocketBase process to the foreground
wait $PB_PID

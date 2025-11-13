#!/bin/bash
# === Load latest Minecraft backup ===

BACKUP_DIR="/home/csw/minecraft-backups"
WORLD_DIR="/home/csw/minecraft-server/data/world"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
LOGPATH="/home/csw/minecraft-server"
LOGFILE="$LOGPATH/minecraft.log"
MAXLINES=150

echo "##############################################"
echo "LOG FROM $DATE | LOAD-BACKUP"
echo "##############################################"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "[ERROR] Backup directory does not exist: $BACKUP_DIR"
    exit 1
fi

LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/minecraft_*.tar.gz 2>/dev/null | head -n 1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "[ERROR] No backup files found in $BACKUP_DIR"
    exit 1
fi

echo "[INFO] Latest backup found: $LATEST_BACKUP"

docker compose stop minecraft

if [ -d "$WORLD_DIR" ]; then
    echo "[INFO] Removing existing world..."
    rm -rf "$WORLD_DIR"
fi

mkdir -p "$WORLD_DIR"

echo "[INFO] Restoring backup..."
tar -xzf "$LATEST_BACKUP" -C "$WORLD_DIR"

docker compose start minecraft

echo "[INFO] Backup restored successfully!"


# === Logs ===
tail -n 100 "$LOGFILE" > "$LOGPATH/minecraft.tmp" && mv "$LOGPATH/minecraft.tmp" "$LOGFILE"

echo "[INFO] Backup completed: $BACKUP_NAME"

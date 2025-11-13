#!/bin/bash
# === Minecraft Docker Backup Script ===
set -e
source ../.env

# === configuration ===
CONTAINER="$MINECRAFT_CONTAINER"
BACKUP_DIR="/home/csw/minecraft-backups"
DATA_DIR="/home/csw/minecraft-server/data/world"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_NAME="minecraft_${DATE}.tar.gz"
MAX_BACKUPS=10
LOGPATH="/home/csw/minecraft-server"
LOGFILE="$LOGPATH/minecraft.log"
MAXLINES=150

echo "##############################################"
echo "LOG FROM $DATE | BACKUP-SCRIPT"
echo "##############################################"

echo "[INFO] Minecraft CSW-server Backup script"
echo "[INFO] Backup in 5min"

mkdir -p "$BACKUP_DIR"

# === warn players ===
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Server Backup starts in 5 minutes!"
sleep 1
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Server Backup starts in 1 minute!"
sleep 1
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Server Backup starting..."

# === Backup ===
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-off
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-all flush

echo "[INFO] starting backup at $(date)..."
tar --exclude="*.sqlite*" -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$DATA_DIR" .

docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-on
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§a[Server]§r Backup succesful!"

# === delete old backups ===
cd "$BACKUP_DIR" || exit
ls -t | grep "minecraft_.*\.tar\.gz" | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm --

# === Logs ===
tail -n 100 "$LOGFILE" > "$LOGPATH/minecraft.tmp" && mv "$LOGPATH/minecraft.tmp" "$LOGFILE"

echo "[INFO] Backup completed: $BACKUP_NAME"

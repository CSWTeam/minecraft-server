#!/bin/bash
# === Minecraft Docker Backup Script ===

# === Konfiguration ===
CONTAINER="minecraft"
BACKUP_DIR="/home/csw/minecraft_backups"
DATA_DIR="/home/csw/data/world"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_NAME="minecraft_${DATE}.tar.gz"
MAX_BACKUPS=10

echo "[INFO] Minecraft CSW-server Backup script"
echo "[INFO] Backup in 5min"

mkdir -p "$BACKUP_DIR"

# === warn players ===
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Server Backup starts in 5 minutes!"
sleep 240
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Server Backup starts in 1 minute!"
sleep 60
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Server Backup starting..."

# === Backup ===
docker exec "$CONTAINER" rcon-cli save-off
docker exec "$CONTAINER" rcon-cli save-all flush

echo "[INFO] starting backup at $(date)..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$DATA_DIR" .

docker exec "$CONTAINER" rcon-cli save-on
docker exec "$CONTAINER" rcon-cli say "§a[Server]§r Backup succesful!"

# === delete old backups ===
cd "$BACKUP_DIR" || exit
ls -t | grep "minecraft_.*\.tar\.gz" | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm --

# === Logfile kürzen auf max. 100 Zeilen ===
LOGFILE="/var/log/minecraft-backup.log"
MAXLINES=100

# === Logs ===
tail -n 100 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"

echo "[INFO] Backup completed: $BACKUP_NAME"

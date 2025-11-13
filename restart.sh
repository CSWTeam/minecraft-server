#!/bin/bash
# === Minecraft restarting script ===
set -e
source .env

# === configuration ===
CONTAINER="$MINECRAFT_CONTAINER"
COMPOSE_DIR="/home/csw/minecraft-server"
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
LOGPATH="/home/csw/minecraft-server"
LOGFILE="$LOGPATH/minecraft.log"
MAXLINES=150

echo "##############################################"
echo "LOG FROM $DATE | RESTART-SCRIPT"
echo "##############################################"


# === warn player ===
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Restarting Server in 5 minutes!"
sleep 1
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Restarting Server in 1 minute!"
sleep 1

# === Saving world ===
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§e[Server]§r Saving world..."
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-off
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-all flush
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 save-on
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§a[Server]§r Succesfully saved world."
docker exec "$CONTAINER" rcon-cli --port "$RCON_PORT" --password "$RCON_PASSWORD" \
 say "§a[Server]§r Restarting Server now..."

# === restart container ===
cd "$COMPOSE_DIR" || exit
docker compose restart minecraft


# === Logs ===
tail -n 100 "$LOGFILE" > "$LOGPATH/minecraft.tmp" && mv "$LOGPATH/minecraft.tmp" "$LOGFILE"

echo "[INFO] finished"

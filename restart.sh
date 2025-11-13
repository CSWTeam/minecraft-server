#!/bin/bash
# === Minecraft restarting script ===

# === configuration ===
CONTAINER="minecraft"
COMPOSE_DIR="/home/csw/minecraft-server"

# === warn player ===
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Restarting Server in 5 minutes!"
sleep 240
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Restarting Server in 1 minute!"
sleep 60

# === Saving world ===
docker exec "$CONTAINER" rcon-cli say "§e[Server]§r Saving world..."
docker exec "$CONTAINER" rcon-cli save-off
docker exec "$CONTAINER" rcon-cli save-all flush
docker exec "$CONTAINER" rcon-cli save-on
docker exec "$CONTAINER" rcon-cli say "§a[Server]§r Succesfully saved world."
docker exec "$CONTAINER" rcon-cli say "§a[Server]§r Restarting Server now..."

# === restart container ===
docker compose down
docker compose up -d

cd "$COMPOSE_DIR" || exit
docker compose restart minecraft

sleep 60
docker exec "$CONTAINER" rcon-cli say "§a[Server]§r Server is back online!"


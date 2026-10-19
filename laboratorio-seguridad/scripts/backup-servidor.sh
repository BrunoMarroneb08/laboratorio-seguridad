#!/bin/bash
# /usr/local/sbin/backup-servidor.sh
# Backup cifrado de servidor-ubuntu
set -eu

DESTINO="/var/backups/servidor"
LLAVE="/root/backup-pub.asc"
RETENCION_DIAS=7
FECHA=$(date +%Y-%m-%d_%H%M)
ARCHIVO="$DESTINO/backup-$FECHA.tar.gz.gpg"

mkdir -p "$DESTINO"
chmod 700 "$DESTINO"

# Comprimir y cifrar en un solo paso (nunca queda una copia sin cifrar en disco)
tar -czf - --exclude='/home/bruno/.cache' /etc /var/www /home/bruno 2>/dev/null \
  | gpg --batch --yes --trust-model always --recipient-file "$LLAVE" --encrypt --output "$ARCHIVO"

# Verificar que el backup no esté vacío
if [ ! -s "$ARCHIVO" ]; then
  logger -t backup-servidor "ERROR: backup vacío o fallido: $ARCHIVO"
  exit 1
fi

# Borrar backups de más de 7 días
find "$DESTINO" -name 'backup-*.tar.gz.gpg' -mtime +$RETENCION_DIAS -delete

logger -t backup-servidor "Backup creado: $ARCHIVO ($(du -h "$ARCHIVO" | cut -f1))"

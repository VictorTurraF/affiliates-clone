#!/usr/bin/env bash
# Run on the Docker host, from any directory. Never commit backup contents.
set -Eeuo pipefail
umask 077

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
docker compose config --quiet
wp_id="$(docker compose ps -q wordpress)"
db_id="$(docker compose ps -q db)"
if [[ -z "$wp_id" || -z "$db_id" ]]; then
  echo 'Start both services with docker compose up -d before backing up.' >&2
  exit 1
fi
for container_id in "$wp_id" "$db_id"; do
  [[ "$(docker inspect --format '{{.State.Running}}' "$container_id")" == true ]] || {
    echo 'Both services must be running before the backup.' >&2
    exit 1
  }
done

backup_root="$HOME/.local/share/affiliates-backups"
mkdir -p "$backup_root"
chmod 700 "$backup_root"
staging="$(mktemp -d "$backup_root/.incomplete-XXXXXXXX")"
restart_needed=0
cleanup() {
  result=$?
  trap - EXIT
  if (( restart_needed )); then
    if ! docker compose start wordpress; then
      echo 'Could not restart WordPress. Run docker compose start wordpress.' >&2
      result=1
    fi
  fi
  if (( result != 0 )); then
    echo "Backup did not finish successfully. Inspect: $staging" >&2
  fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

echo 'Pausing WordPress; MySQL stays running for the database export...'
restart_needed=1
docker compose stop -t 60 wordpress
[[ "$(docker inspect --format '{{.State.Running}}' "$wp_id")" == false ]]
if [[ "$(docker inspect --format '{{.State.ExitCode}}' "$wp_id")" == 137 ]]; then
  echo 'WordPress was forcibly stopped; retry after checking its logs.' >&2
  exit 1
fi

echo 'Exporting the database...'
docker compose exec -T db sh -c \
  'MYSQL_PWD="$MYSQL_PASSWORD" exec mysqldump --user="$MYSQL_USER" --single-transaction --quick --no-tablespaces --set-gtid-purged=OFF --triggers --hex-blob "$MYSQL_DATABASE"' \
  | gzip > "$staging/database.sql.gz"

echo 'Archiving WordPress files, plugins, themes and uploads...'
docker cp -a "$wp_id:/var/www/html/." - | gzip > "$staging/wordpress.tar.gz"
cp .env compose.yaml "$staging/"
docker inspect --format '{{.Config.Image}} {{.Image}}' "$wp_id" "$db_id" > "$staging/images.txt"
docker compose version > "$staging/compose-version.txt"
date -u +'%Y-%m-%dT%H:%M:%SZ' > "$staging/created-at-utc.txt"

echo 'Checking archive integrity...'
gzip -t "$staging/database.sql.gz" "$staging/wordpress.tar.gz"
gzip -dc "$staging/database.sql.gz" | tail -n 10 | grep -q -- '-- Dump completed on'
tar -tzf "$staging/wordpress.tar.gz" > "$staging/wordpress-files.txt"
grep -Eq '(^|/)wp-config.php$' "$staging/wordpress-files.txt"
grep -Eq '(^|/)wp-content/' "$staging/wordpress-files.txt"
(
  cd "$staging"
  sha256sum database.sql.gz wordpress.tar.gz .env compose.yaml images.txt compose-version.txt created-at-utc.txt wordpress-files.txt > SHA256SUMS
  sha256sum --check --quiet SHA256SUMS
)

docker compose start wordpress
restart_needed=0
[[ "$(docker inspect --format '{{.State.Running}}' "$wp_id")" == true ]]
backup_dir="$backup_root/$(date -u +'%Y%m%dT%H%M%SZ')-${staging##*-}"
mv "$staging" "$backup_dir"
echo "Backup created and archive checks passed: $backup_dir"
echo 'WordPress restarted. Check the shop in your browser.'
echo 'This backup contains credentials and customer data: keep it private and outside Git.'
echo 'A full restore test is still required; copy the backup to another device for disk-failure protection.'

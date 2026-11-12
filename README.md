# Online stationery shop — demo

**English** | [Português (Brasil)](README.pt-BR.md)

A local WordPress and WooCommerce shop that will support a future affiliate platform. The shop targets an Australian audience, uses Australian English and prices products in AUD. All purchases will be simulated.

## Current progress

Day 1 delivered a working local shop: WordPress and WooCommerce, AUD pricing, guest checkout, A$10 flat-rate shipping and manual demo payments. The first notebook purchase and its manual transition to Processing were confirmed by the project owner.

See the [Day 1 log](docs/day-01/README.md) for settings, validation and outstanding work.

## Local environment

Docker Compose sets up WordPress and MySQL using official images. No Dockerfile is required. WooCommerce and the shop settings were configured manually in the dashboard; a fresh clone does not recreate that database state automatically.

Prerequisites: a running Docker Engine or Docker Desktop installation with Docker Compose v2 or later.

From the project directory:

```bash
cp -n .env.example .env
```

Set `DB_PASSWORD` in `.env` before the first startup. This is the database password, not the WordPress administrator password. Do not commit `.env` to Git.

```bash
docker compose config --quiet
docker compose up -d
docker compose ps
```

Wait for the database to become healthy, then open http://localhost:8080. In the WordPress setup wizard, select English (Australia), enter a temporary shop name and create your administrator account. The dashboard is available at http://localhost:8080/wp-admin/.

The shop is accessible only from this computer. If the port is already in use, change `WORDPRESS_PORT` before installation. Changing the port afterwards also requires updating the WordPress URLs.

### Daily use

```bash
# Start
docker compose up -d

# View logs
docker compose logs --tail=100 wordpress db

# Stop while preserving data
docker compose down
```

Volumes preserve the database, images, themes and plugins between restarts. Do not use `docker compose down -v` for a normal shutdown: that option deletes the shop's data. Volumes are not a substitute for backups and are not tracked by Git.

The images use moving tags (`wordpress:php8.3-apache` and `mysql:8.4`). After validating the first run, recording their digests will allow the exact versions to be pinned. Changing the password in `.env` after initialising the database does not change the password stored in the database.

## Backup

With both services running, run this on the Docker host:

```bash
bash scripts/backup.sh
```

Backups are stored outside the repository in `~/.local/share/affiliates-backups/`, with private permissions. The script temporarily stops WordPress, exports MySQL, archives WordPress files and restarts WordPress. It includes `.env` and `compose.yaml`, so backups contain credentials and may contain customer data. Do not commit or share them publicly.

Archive integrity and checksums are checked automatically. A successful backup does not prove restoration: a full restore test remains pending. Keep an additional copy on another device. If execution fails, the script retains an `.incomplete-*` folder for inspection and attempts to restart WordPress.

## Agreed scope

- Approximately 12 simple stationery products, without variations.
- Categories: notebooks and planners; writing and highlighting; organisation.
- Photo, description, price and availability for each product.
- Product page, cart, checkout and order confirmation.
- Guest checkout, Australian addresses and AUD currency.
- A fictional flat shipping rate and simulated payments, with no real charges.
- A visible demo notice on the shop.
- Product and order administration.
- Scenarios for pending/approved payments, discounts, cancellations and full/partial refunds.
- Future affiliate integration with order and line-item identification and duplicate commission prevention.

Recommendations, advanced search, complex categories and real shipping/payment integrations are out of scope. Configurable commission rules will be defined during the affiliate platform stage.

## Upcoming milestones

One commit per day, with a verifiable deliverable.

- Day 1 backup: created outside Git on 12 November 2026; archive integrity and checksum checks passed, and WordPress restarted, as confirmed by the project owner. Full restoration testing and the daily commit are still pending.
- Day 2 proposal: expand the demo catalogue and test discounts, cancellations and refunds.
- Later: implement affiliate tracking and configurable commissions.

The current checkout uses an offline payment method labelled for demonstration. No real payment provider is connected. Dashboard changes live in the Docker volumes, not in Git.

## Reference

[Official WordPress image](https://hub.docker.com/_/wordpress)

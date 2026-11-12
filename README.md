# Online stationery shop — demo

**English** | [Português (Brasil)](README.pt-BR.md)

A local WordPress and WooCommerce shop that will support a future affiliate platform. The shop targets an Australian audience, uses Australian English and prices products in AUD. All purchases will be simulated.

## Day 1: local environment

This stage sets up WordPress and MySQL using official images. WooCommerce, products and simulated payments will be configured in the following stages. No Dockerfile is required.

Prerequisites: a running Docker Engine or Docker Desktop installation with Docker Compose v2 or later.

From the project directory:

```bash
cp .env.example .env
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

One commit per day, with a verifiable deliverable. After validating the environment: install/configure WooCommerce, add the demo catalogue and validate the purchase flow. Do not connect a real payment provider in the WooCommerce wizard.

## Reference

[Official WordPress image](https://hub.docker.com/_/wordpress)

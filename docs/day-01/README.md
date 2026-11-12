# Day 1 — local shop and first demo order

**English** | [Português (Brasil)](README.pt-BR.md) | [Project README](../../README.md)

Date: 12 November 2026 (Australia/Perth).

## Outcome

The project owner completed a guest purchase in the local WooCommerce shop and manually changed the order from On hold to Processing. No payment was collected and no shipment was arranged. This is a manual demonstration of the order lifecycle, not a test of a payment gateway or affiliate commissions.

## Environment

- WordPress (`wordpress:php8.3-apache`) and MySQL (`mysql:8.4`) run through Docker Compose.
- The shop is bound to `127.0.0.1:8080` by default.
- Named volumes `wordpress_data` and `db_data` preserve files and database contents.
- `.env` contains the local database password and is excluded from Git.
- WooCommerce was installed and activated manually in the WordPress dashboard.
- Existing Docker volumes were retained; no Btrfs migration or snapshot workflow was implemented.

## Dashboard configuration

| Setting | Day 1 configuration |
| --- | --- |
| Language | English (Australia) |
| Country/state | Australia — Western Australia |
| Store address | Demonstration address in Perth, postcode 6000 |
| Currency | AUD, symbol on the left, two decimal places |
| Number formatting | Comma thousands separator and decimal point |
| Selling locations | Australia only |
| Shipping locations | Countries where the shop sells |
| Default customer location | Shop country/region |
| Taxes | Disabled for this demonstration |
| Coupons | Enabled; not yet tested |
| Accounts | Guest checkout enabled; account creation at checkout disabled |
| Shipping zone | Australia |
| Shipping method | Flat rate: `Standard delivery — Demo`, A$10 per order, tax status None |
| Payment method | Offline cheque/check payments, renamed `Demo payment — no charge` |
| Visibility | Live, allowing logged-out visitors on localhost |

Payment description: “This is a demonstration store. No payment will be collected and no products will be shipped.”

Payment instructions: “Your demo order has been received. No payment is required.”

Live visibility does not expose this localhost-only Docker setup to the internet. The demo message is configured in the payment method; a separate site-wide demo notice is still outstanding.

## Product and images

The first product is `A5 Everyday Notebook`, a simple physical product priced at A$12.90, with SKU `PAPER-001`, In stock status and category `Notebooks & Planners`.

- [Notebook image](../../assets/products/a5-notebook.png): generated and uploaded to the product.
- [Pastel highlighters image](../../assets/products/pastel-highlighters.png): generated for a future product; no highlighter product has been confirmed as created.
- [Image prompts](../../assets/products/prompts.md).

## Manual validation

The project owner reported completing the following steps in the browser:

1. Viewed the shop in a private window after disabling Coming soon mode.
2. Added one notebook and completed guest checkout with the demo payment method.
3. Confirmed the order: A$12.90 product + A$10.00 shipping = A$22.90.
4. Opened the order in the dashboard and changed On hold to Processing.

This log records the owner's confirmation; it is not an automated test report. Customer details, credentials and order identifiers are intentionally omitted.

## Backup result

The project owner ran `bash scripts/backup.sh` and shared successful output. Backup `20261112T084625Z-QoxOU2jO` was created under `~/.local/share/affiliates-backups/`, outside Git. The database export and WordPress archive passed integrity and checksum checks, and the WordPress container restarted. Browser availability after restart and a full restoration have not yet been verified.

The backup includes credentials and potentially customer data. Keep it private; a separate-device copy is not yet confirmed.

## Still pending

- Test a full restoration of the completed backup in an isolated environment.
- Verify the Git repository and create the Day 1 commit; no commit is recorded as completed here.
- Add a site-wide demonstration notice.
- Expand the catalogue towards the planned 12 products and three categories.
- Test coupons, multiple quantities/items, cancellations and full/partial refunds.
- Pin validated image digests and make dashboard setup reproducible.
- Implement affiliate attribution and commission rules in a later stage.

The repository contains environment configuration, documentation and image assets. It does not contain the running shop's database, installed plugins or uploaded media volume. A fresh installation requires manual setup or a verified backup restore.

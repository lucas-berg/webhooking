# Webhooking

A self-hosted webhook inbox and lightweight automation workbench. Accounts are optional: open the application to start receiving requests.

## Requirements

- Ruby 3.4.10 and Bundler 4
- Node.js 22.12+ and Yarn 1.22.22
- PostgreSQL and Redis 7+

## Local development

```sh
bundle install
yarn install --frozen-lockfile
cp .env.template .env
bin/rails db:prepare
bin/dev
```

Open http://localhost:3005. Review `.env` before starting; `DATABASE_URL` overrides individual PostgreSQL connection settings. Run `bundle exec sidekiq -C config/sidekiq.yml` for scheduled jobs.

## Checks

```sh
RAILS_ENV=test bin/rails db:prepare
bundle exec rspec
bin/rails zeitwerk:check
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Use a dedicated test database. See [the upgrade guide](docs/upgrade.md) before upgrading an existing deployment.

## Docker

Set `POSTGRES_PASSWORD`, `SECRET_KEY_BASE` (generate with `bin/rails secret`) and `WEBSITE_URL` in `.env`, then run `docker compose up --build`. The web process runs on port 3005; a separate worker executes scheduled requests. Accounts and admin credentials are never seeded by default.

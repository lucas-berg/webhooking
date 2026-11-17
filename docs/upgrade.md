# Upgrade guide

## Runtime baseline

This upgrade targets Ruby 3.4.10, Rails 8.1.4.1, Devise 5, Sidekiq 8, Pagy 43 and Vite Ruby 3.11. Use the committed lockfiles. Rails defaults now target 8.1; sign in again if an existing session expires during the transition.

1. Back up PostgreSQL and uploaded files before changing the deployment.
2. Stop web and worker processes together; deploy the application and schema changes as one release.
3. Install the Ruby version in `.ruby-version`, then run `bundle install` and `yarn install --frozen-lockfile`.
4. Set `DATABASE_URL` or review `.env.template`. The old `POSTGRES_DBPOSTGRES_DB` key is accepted as a fallback; prefer `POSTGRES_DB`.
5. Run `bin/rails db:migrate` against the existing database. Do not run `db:reset` or `db:schema:load` on existing data.
6. Build assets and restart both web and worker processes. Verify receiving requests before routing normal traffic.

## Containers and existing data

The new Compose setup uses PostgreSQL 17, Redis 7.4 and named volumes. Previous releases used PostgreSQL 14 and host bind mounts under `datadir/`. Existing files are not deleted or automatically migrated. Do not attach a PostgreSQL 14 data directory to PostgreSQL 17. Export the old database with `pg_dump`, restore it into the new database with `pg_restore`, and copy existing uploads into the uploads volume before switching traffic. Alternatively, retain your existing supported external PostgreSQL service and connect the upgraded application to it.

Compose requires an explicit database password and application secret. Keep the same `SECRET_KEY_BASE` across releases. The image excludes local environment files and `config/master.key`.

## Dependency cleanup

Unused React Rails, Tailwind Rails, SassC, charting, OAuth, annotation and legacy development dependencies were removed. HTTP actions depend explicitly on `rest-client` rather than receiving it through `api_tools`. The previous GitHub OAuth route was disabled and had no implemented callback; email/password authentication remains supported.

Pagy uses the current `Pagy::Method` and `series_nav` APIs. Tests use transactional fixtures instead of truncating the database. The original test suite contained nine pending placeholders; functional coverage is added in subsequent commits.

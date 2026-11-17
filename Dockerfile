FROM node:22-bookworm-slim AS node
RUN npm install --global yarn@1.22.22 --force

FROM ruby:3.4.10-slim-bookworm
WORKDIR /app
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git libpq-dev libvips curl && rm -rf /var/lib/apt/lists/*
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/yarn /opt/yarn
RUN ln -s /opt/yarn/bin/yarn.js /usr/local/bin/yarn
ENV RAILS_ENV=production BUNDLE_WITHOUT=development:test RAILS_SERVE_STATIC_FILES=1 RAILS_LOG_TO_STDOUT=1
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
RUN groupadd --system app && useradd --system --gid app app && chown -R app:app /app
USER app
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

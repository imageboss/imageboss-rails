# Build with: docker compose build ruby33
# Or for 2.7: docker compose build ruby27
# RUBY_VERSION is passed as build-arg from docker-compose.yml
ARG RUBY_VERSION=3.3
FROM ruby:${RUBY_VERSION}

RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Default: run tests (override with docker compose run ... command)
CMD ["sh", "-c", "bundle install && bin/test"]

# Contributing to imageboss-rails

Thank you for considering contributing to imageboss-rails.

## Development setup

1. Clone the repository.
2. Install dependencies: `bundle install` (use `RAILS_VERSION=6.0.2` or another version to test against a specific Rails).
3. Run tests: `./bin/test`.

## Running tests

```bash
./bin/test
```

To test against a specific Rails version:

```bash
RAILS_VERSION=6.1.7 bundle install
RAILS_VERSION=6.1.7 ./bin/test
```

## Pull requests

- Keep changes focused and the diff small when possible.
- Follow the existing code style.
- Add or update tests for new behavior.
- Update the README or CHANGELOG if you change user-facing behavior.

## Releasing

See [RELEASING.md](RELEASING.md) for how to bump the version and publish a new release to RubyGems.org.

## Reporting issues

Open an issue on GitHub with a clear description, steps to reproduce, and your environment (Ruby and Rails versions).

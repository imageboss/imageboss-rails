# Releasing a new version

Release from Docker so the gem builds with a consistent Ruby and dependency set (avoids local gem/Ruby version issues).

## 1. Bump version and update CHANGELOG

- **Version** in `lib/imageboss/rails/version.rb`:
  - Patch: `2.1.1` → `2.1.2` (bug fixes)
  - Minor: `2.1.1` → `2.2.0` (new features, backward compatible)
  - Major: `2.1.1` → `3.0.0` (breaking changes)

- **CHANGELOG.md**: Replace `## [Unreleased]` with `## [X.Y.Z] - YYYY-MM-DD`, then add a new empty `## [Unreleased]` at the top.

## 2. Commit the release

```bash
git add lib/imageboss/rails/version.rb CHANGELOG.md
git commit -m "Release vX.Y.Z"
```

## 3. Release with Docker

**Prerequisites:**

- [RubyGems.org](https://rubygems.org) API key: create at https://rubygems.org/settings/edit, then set it when running:
  ```bash
  export GEM_HOST_API_KEY=your_api_key_here
  ```
- Git push access: the release container runs `git push` for the commit and tag. Either:
  - **SSH**: the compose file mounts `~/.ssh` so your SSH key is used (default).
  - **HTTPS**: if you use a token, ensure the repo remote uses it or run with a credential helper; you may need to mount a different volume instead of `~/.ssh`.

**Run the release:**

```bash
docker compose build release
docker compose run --rm -e GEM_HOST_API_KEY release
```

Or in one go:

```bash
GEM_HOST_API_KEY=your_api_key docker compose run --rm release
```

The container will `bundle install` (with default Rails dependency) and then run `rake release`, which:

- Builds the gem into `pkg/`
- Creates git tag `vX.Y.Z`
- Pushes the current branch and the tag to the remote
- Pushes the gem to RubyGems.org

## 4. Release without Docker (optional)

If you prefer to release from the host:

```bash
bundle install   # no RAILS_VERSION so gemspec uses default
bundle exec rake release
```

You need Ruby and Bundler installed; use `gem signin` or set `GEM_HOST_API_KEY` for RubyGems.

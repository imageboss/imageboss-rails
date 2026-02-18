# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2025-02-18

### Added
- **Responsive images (srcset)**: `imageboss_tag` now supports `srcset_options` with `widths` array or `min_width`/`max_width` (and optional `width_step`) to generate a `srcset` attribute.
- **Picture tag**: `imageboss_picture_tag` for `<picture>` elements with breakpoints and different URL params per media query.
- **Lazy loading**: `attribute_options` (e.g. `{ src: 'data-src', srcset: 'data-srcset' }`) and optional placeholder via `tag_options[:src]` for use with lazysizes or similar.
- **Multi-source configuration**: `config.imageboss.sources` (hash of source name => secret) and `config.imageboss.default_source`. Helpers accept optional `source:` to override.
- **asset_host**: When `config.imageboss.enabled` is false, `config.imageboss.asset_host` is used as the base URL for fallback image paths.
- **Usage in models/serializers**: Documented including `ImageBoss::Rails::UrlHelper` to call `imageboss_url` outside views.

### Changed
- **Rails 5+ only**: Official support and CI are now Rails 5, 6, 7, 8 only. Rails 4 and below are no longer tested or supported.
- **Client no longer memoized**: Each `imageboss_url` / tag call builds the client from current config so per-request or multi-tenant config is respected.
- **imageboss_url** now accepts optional 4th keyword argument `source:` and supports `options` as a default empty hash.
- **imageboss_tag** keeps backward compatibility: 4th positional arg is merged into tag options; new options are `tag_options:`, `srcset_options:`, `attribute_options:`, `source:`.

### Fixed
- README typo: "you can't disable" → "you can disable", "spacific" → "specific", "thos" → "those".

## [Previous versions]

See git history for changes before this changelog was added.

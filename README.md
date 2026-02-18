[![ImageBoss logo](https://img.imageboss.me/boss-images/width/180/emails/logo-2@2x.png)](https://imageboss.me)

# ImageBoss Helper for Ruby On Rails
[![CI](https://github.com/imageboss/imageboss-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/imageboss/imageboss-rails/actions) [![Gem Version](https://badge.fury.io/rb/imageboss-rails.svg)](https://badge.fury.io/rb/imageboss-rails)

Official Gem for generating ImageBoss URLs with Ruby On Rails. It's built on top of [imageboss-rb](https://github.com/imageboss/imageboss-rb)
to offer rails specific features.

[ImageBoss](https://imageboss.me/) is a service designed to handle on-demand image processing with content aware recognition, progressive scans, compression, CDN and more.

We recommend using something like [Paperclip](https://github.com/thoughtbot/paperclip), [Refile](https://github.com/refile/refile), [Carrierwave](https://github.com/carrierwaveuploader/carrierwave), or [s3_direct_upload](https://github.com/waynehoover/s3_direct_upload) to handle uploads and make them available. After they've been uploaded, you can then serve them using this gem or you can disable ImageBoss for specific environments. Read on.

**Table of Contents**
- [ImageBoss Helper for Ruby On Rails](#imageboss-helper-for-ruby-on-rails)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Configuration](#configuration)
      - [Same configuration across all environments](#same-configuration-across-all-environments)
      - [Environment specific configuration](#environment-specific-configuration)
      - [Multi-source configuration](#multi-source-configuration)
    - [Signing your URLs](#signing-your-urls)
    - [imageboss_tag](#imagebosstag)
    - [Responsive images (srcset)](#responsive-images-srcset)
    - [imageboss_picture_tag](#imageboss_picture_tag)
    - [Lazy loading](#lazy-loading)
    - [Native Rails image_tag options](#native-rails-imagetag-options)
    - [imageboss_url](#imagebossurl)
    - [Usage in models and serializers](#usage-in-models-and-serializers)
    - [Usage in Sprockets](#usage-in-sprockets)
    - [Disable ImageBoss URL on specific environments](#disable-imageboss-url-on-specific-environments)
  - [Compatibility](#compatibility)
  - [Developer](#developer)

## Installation
Just run the following:
```bash
$ bundle add imageboss-rails
```

Or install it yourself as:
```bash
$ gem install imageboss-rails
```

## Usage
`imageboss-rails` provides helpers to make the integration easier. To know all operations and options available please read the [ImageBoss Docs](https://imageboss.me/docs).

### Configuration
#### Same configuration across all environments
Just add the following to `config/application.rb`:

```ruby
Rails.application.configure do
  config.imageboss.source = "mywebsite-assets"
end
```
#### Environment specific configuration
Just add the following to `config/environments/production.rb`:
```ruby
Rails.application.configure do
  config.imageboss.source = "mywebsite-assets-prod"
end
```

#### Multi-source configuration
When you have multiple ImageBoss sources (e.g. different buckets or CDNs), use `sources` and `default_source`. You cannot use `source` and `sources` together.

```ruby
Rails.application.configure do
  config.imageboss.sources = {
    "mywebsite-assets"  => "your-secret-token",  # signed URLs
    "mywebsite-assets-2" => nil                   # unsigned
  }
  config.imageboss.default_source = "mywebsite-assets"
end
```

Then pass the source when generating a URL or tag:

```ruby
<%= imageboss_url('path/to/image.jpg', :cover, { width: 100, height: 100 }, source: 'mywebsite-assets-2') %>
<%= imageboss_tag('path/to/image.jpg', :cover, { width: 100, height: 100 }, source: 'mywebsite-assets-2') %>
```

### Signing your URLs
Read more about this feature here:
https://www.imageboss.me/docs/security

```ruby
Rails.application.configure do
  config.imageboss.secret = "<MY_SECRET>"
end
```

### imageboss_tag
Just like Rails' [image_tag](https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_tag) it will generate an `<img>` tag for you - but wrapped by the ImageBoss gem adding some more functionalities. The syntax is the following:
```ruby
<%= imageboss_tag('my-nice-image', :cover, { width: 100, height: 100 }) %>
```
Will output the following:
```html
<img
  alt="my-nice-image"
  src="https://img.imageboss.me/mywebsite-assets/cover/100x100/assets/my-nice-image.jpg"
/>
```

### Responsive images (srcset)
Generate a responsive `srcset` so the browser can choose the right image size. Use `srcset_options` with either a `widths` array or `min_width` and `max_width` (and optional `width_step`, default 160):

```ruby
<%= imageboss_tag('my-nice-image', :width, { width: 800 },
  srcset_options: { widths: [320, 640, 960, 1280] },
  sizes: "100vw",
  alt: "Responsive image") %>
```

Or with a width range:

```ruby
<%= imageboss_tag('my-nice-image', :width, {},
  srcset_options: { min_width: 320, max_width: 1280, width_step: 160 },
  sizes: "(max-width: 640px) 100vw, 50vw",
  alt: "Responsive image") %>
```

### imageboss_picture_tag
Generate a `<picture>` element with different ImageBoss parameters per breakpoint (e.g. for art-directed images):

```ruby
<%= imageboss_picture_tag('hero.jpg', :cover, { width: 800, height: 600 },
  breakpoints: {
    '(max-width: 640px)' => { url_params: { width: 400, height: 300 } },
    '(min-width: 641px)' => { url_params: { width: 800, height: 600 } }
  },
  img_tag_options: { alt: "Hero" }) %>
```

### Lazy loading
Use `attribute_options` to output `data-src` and `data-srcset` instead of `src` and `srcset`, and set a placeholder `src` (e.g. a low-quality or tiny image). Works well with [lazysizes](https://github.com/aFarkas/lazysizes):

```ruby
<%= imageboss_tag('my-nice-image', :cover, { width: 100, height: 100 },
  attribute_options: { src: 'data-src', srcset: 'data-srcset' },
  tag_options: { src: 'placeholder.jpg' },
  alt: "Lazy loaded") %>
```

### Native Rails image_tag options
If you want to provide native `image_tag` helper options just add them to the end of the helper:
```ruby
<%= imageboss_tag('my-nice-image', :cover, { width: 100, height: 100, options: { blur: 2 } }, alt: "Sunny Lisbon!") %>
```
Will output the following:
```html
<img
  alt="Sunny Lisbon!"
  src="https://img.imageboss.me/mywebsite-assets/cover/100x100/blur:2/assets/my-nice-image.jpg"
/>
```

### imageboss_url
Just like Rails' [asset_url](https://apidock.com/rails/ActionView/Helpers/AssetUrlHelper/asset_url) but it will output your `path` with a fully valid ImageBoss URL.
```ruby
<%= imageboss_url('my-nice-image', :width, { width: 100 }) %>
```
Will output the following:
```
https://img.imageboss.me/mywebsite-assets/width/100/assets/my-nice-image.jpg
```

With multi-source you can pass `source:`:

```ruby
<%= imageboss_url('my-nice-image', :width, { width: 100 }, source: 'mywebsite-assets-2') %>
```

### Usage in models and serializers
`imageboss_url` lives in `UrlHelper`, so you can use it outside views (e.g. in serializers or models) by including the helper:

```ruby
class UserSerializer
  include ImageBoss::Rails::UrlHelper

  def avatar_url
    imageboss_url(user.avatar_path, :cover, { width: 100, height: 100 })
  end
end
```

### Usage in Sprockets

`imageboss_url` is also pulled in as a Sprockets helper, so you can generate ImageBoss URLs in your asset pipeline files. For example, here's how it would work inside an `.scss.erb` file:

```scss
.user-profile {
  background-image: url(<%= imageboss_url('a-nice-profile.svg', :cover, { width: 400, height: 300 }) %>);
}
```

### Disable ImageBoss URL on specific environments
If on `development` or `test` environment you are not sending images to the cloud you can disable the generation of ImageBoss URLs for those environments. For example, if you want to disable on `development`, just add the following to your `config/environments/development.rb` file.

```ruby
config.imageboss.enabled = false
```
With this configured, in all places you call `imageboss_url` or `imageboss_tag` the `src` or the `url` generated will fallback straight to your localhost images. For example instead of generating this URL:
```
https://img.imageboss.me/mywebsite-assets/cover/100x100/assets/my-nice-image.jpg
```
it will output this:
```
http://localhost:3000/assets/my-nice-image.jpg
```
This is nice because you won't need to add any extra code to handle this yourself.

If you set `config.imageboss.asset_host` (e.g. `"https://mywebsite.com"`), the fallback URL when disabled will use that host instead of the raw path.

## Compatibility
Rails
  - 6
  - 5
  - 4

Ruby
  - 2.6.x
  - 2.4.x
  - 2.3.x
  - 2.2.x
  - 2.1.x

jRuby
  - jruby-9.0.5.x

Rubinius
  - rbx-3.x


## Developer
To run the tests:
```
./bin/test
```

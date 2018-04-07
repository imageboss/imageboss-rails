[![ImageBoss logo](https://service.imageboss.me/width/180/https://imageboss.me/emails/logo-2@2x.png)](https://imageboss.me)

# ImageBoss Helper for Ruby On Rails
[![Build Status](https://travis-ci.org/imageboss/imageboss-rails.svg?branch=master)](https://travis-ci.org/imageboss/imageboss-rails) [![Gem Version](https://badge.fury.io/rb/imageboss-rails.svg)](https://badge.fury.io/rb/imageboss-rails)

Official Gem for generating ImageBoss URLs with Ruby On Rails. It's built on top of [imageboss-rb](https://github.com/imageboss/imageboss-rails)
to offer rails specific features.

[ImageBoss](https://imageboss.me/) is a service designed to handle on-demand image processing with content aware recognition, progressive scans, compression, CDN and more.

We recommend using something like [Paperclip](https://github.com/thoughtbot/paperclip), [Refile](https://github.com/refile/refile), [Carrierwave](https://github.com/carrierwaveuploader/carrierwave), or [s3_direct_upload](https://github.com/waynehoover/s3_direct_upload) to handle uploads and make them available. After they've been uploaded, you can then serve them using this gem or you can't disable ImageBoss for spacific environments. Read on.

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
`imageboss-rails` provide you a few helpers to make the integration easier. To know all operations and options available please read the [ImageBoss Docs](https://imageboss.me/docs).

### Configuration
#### Same configuration across all environemnts
Just add the following to `app/config/application.rb`:

```ruby
Rails.application.configure do
  config.imageboss.source = "https://assets.mywebsite.com"
end
```

### imageboss_tag
Just like the Rails' [image_tag](https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_tag) it will generate an `<img>` tag for you - but wrapped by the ImageBoss gem adding some more functionalities. The syntax is the following:
```ruby
<%= imageboss_tag('my-nice-image', :cover, { width: 100, height: 100 }) %>
```
Will output the following:
```html
<img
  alt="my-nice-image"
  src="https://service.imageboss.me/cover/100x100/https://assets.mywebsite.com/assets/my-nice-image.jpg"
/>
```


### Native Rails image_tag options
If you want to provide native `image_url` helper options just add them to the end of the helper:
```ruby
<%= imageboss_tag('my-nice-image', :cover, { width: 100, height: 100 }, alt: "Sunny Lisbon!") %>
```
Will output the following:
```html
<img
  alt="Sunny Lisbon!"
  src="https://service.imageboss.me/cover/100x100/https://assets.mywebsite.com/assets/my-nice-image.jpg"
/>
```

### imageboss_url
Just like Rails' [asset_url](https://apidock.com/rails/ActionView/Helpers/AssetUrlHelper/asset_url) but it will output your `path` with a fully valid ImageBoss URL.
```ruby
<%= imageboss_url('my-nice-image', :width, { width: 100 }) %>
```
Will output the following:
```
https://service.imageboss.me/width/100/https://assets.mywebsite.com/assets/my-nice-image.jpg
```

### Usage in Sprockets

`imageboss_url` is also pulled in as a Sprockets helper, so you can generate ImageBoss URLs in your asset pipeline files. For example, here's how it would work inside an `.scss.erb` file:

```scss
.user-profile {
  background-image: url(<%= imageboss_url('a-nice-profile.svg', :cover, { width: 400, height: 300 }) %>);
}
```
## Compatibility
Rails
  - 5
  - 4

Ruby
  - 2.4.x
  - 2.3.x
  - 2.2.x
  - 2.1.x

jRuby
  - jruby-9.0.5.x

Rubinius
  - rbx-3.x

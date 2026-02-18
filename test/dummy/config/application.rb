require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'imageboss/rails'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1 if config.respond_to?(:load_defaults)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.imageboss.source = 'mywebsite-assets'
    config.imageboss.asset_host = 'https://mywebsite.com'

    # Silence SQLite boolean serialization deprecation (Rails 5.2+)
    if config.active_record.respond_to?(:sqlite3)
      config.active_record.sqlite3.represent_boolean_as_integer = true if config.active_record.sqlite3.respond_to?(:represent_boolean_as_integer=)
    end
  end
end

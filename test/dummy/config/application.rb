require_relative 'boot'

# Load Rails without ActiveRecord so the dummy app needs no database (no sqlite3).
require 'rails'
require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
# Intentionally skip: require 'active_record/railtie'

Bundler.require(*Rails.groups)
require 'imageboss/rails'

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.1 if config.respond_to?(:load_defaults)

    config.imageboss.source = 'mywebsite-assets'
    config.imageboss.asset_host = 'https://mywebsite.com'

    if config.respond_to?(:active_support) && config.active_support.respond_to?(:to_time_preserves_timezone=)
      config.active_support.to_time_preserves_timezone = :zone
    end
  end
end

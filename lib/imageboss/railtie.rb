require 'rails'
require 'rails/railtie'
require 'imageboss/rails'
require 'imageboss/rails/url_helper'
require 'imageboss/rails/view_helper'

module ImageBoss
  module Rails
    class Railtie < ::Rails::Railtie
      config.imageboss = ActiveSupport::OrderedOptions.new

      initializer 'imageboss-rails.view_helper' do |app|
        ImageBoss::Rails.configure do |config|
          config.imageboss = app.config.imageboss
        end

        Sprockets::Context.send :include, UrlHelper if defined? Sprockets
      end

      # Include after ActionView::Base is fully initialized so we don't trigger
      # "class variable @@debug_missing_translation of ActionView::Base is overtaken by ..."
      # on Ruby 3.2+ with Rails 5.2.
      config.to_prepare do
        ActionView::Base.include(ImageBoss::Rails::ViewHelper)
      end
    end
  end
end

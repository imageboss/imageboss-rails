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

        # Defer including into ActionView::Base until after ActionView has set its class variables.
        # Avoids "class variable @@debug_missing_translation of ActionView::Base is overtaken by ..."
        # on Ruby 3.2+ with Rails 5.2.
        ActiveSupport.on_load(:action_view) do
          ActionView::Base.include(ImageBoss::Rails::ViewHelper)
        end

        Sprockets::Context.send :include, UrlHelper if defined? Sprockets
      end
    end
  end
end

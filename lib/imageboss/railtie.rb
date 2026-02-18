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

      # Register our on_load(:action_view) in after_initialize so we run *after* ActionView's
      # on_load block (which sets @@debug_missing_translation etc.). That avoids
      # "class variable ... is overtaken by ImageBoss::Rails::UrlHelper" on Ruby 3.2+.
      config.after_initialize do
        ActiveSupport.on_load(:action_view) do
          ActionView::Base.include(ImageBoss::Rails::ViewHelper)
        end
      end
    end
  end
end

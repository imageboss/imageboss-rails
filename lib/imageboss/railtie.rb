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

        ActionView::Base.send :include, ViewHelper
        Sprockets::Context.send :include, UrlHelper if defined? Sprockets
      end
    end
  end
end

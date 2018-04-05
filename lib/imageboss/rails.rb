require 'imageboss'
require 'imageboss/railtie' if defined? Rails::Railtie

module ImageBoss
  module Rails
    class Config < ::ActiveSupport::OrderedOptions; end

    def self.config
      @config ||= Config.new
    end

    def self.configure
      yield config
    end
  end
end

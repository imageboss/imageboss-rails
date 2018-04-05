module ImageBoss
  module Rails
    module UrlHelper
      def imageboss_url(path, options)
        imageboss_client.path(path).operation(*options).html_safe
      end

      private

      def imageboss_client
        return @imageboss_client if @imageboss_client
        config = ::ImageBoss::Rails.config.imageboss
        @imageboss_client = ::ImageBoss::Client.new(domain: config[:assets_host])
      end
    end
  end
end

module ImageBoss
  module Rails
    module UrlHelper
      include ActionView::Helpers

      def imageboss_url(path, operation, options)
        imageboss_client
          .path(image_path(path))
          .operation(operation, options)
          .html_safe
      end

      private

      def imageboss_client
        config = ::ImageBoss::Rails.config.imageboss || {}
        client_options = {}
        client_options[:domain] = config[:asset_host]
        client_options[:enabled] = config[:enabled] unless config[:enabled].nil?
        @imageboss_client = ::ImageBoss::Client.new(**client_options)
      end
    end
  end
end

module ImageBoss
  module Rails
    module UrlHelper
      include ActionView::Helpers

      def imageboss_url(path, operation, options)
        imageboss_client
          .path(path)
          .operation(operation, options)
          .html_safe
      end

      private

      def imageboss_client
        config = ::ImageBoss::Rails.config.imageboss || {}
        client_options = {}
        client_options[:source] = config[:source]
        client_options[:secret] = config[:secret] || false
        client_options[:enabled] = config[:enabled] unless config[:enabled].nil?

        @imageboss_client = ::ImageBoss::Client.new(**client_options)
      end
    end
  end
end

module ImageBoss
  module Rails
    module UrlHelper
      include ActionView::Helpers

      # Generate an ImageBoss URL for the given path and operation.
      # When +source+ is given and multi-source is configured, uses that source.
      #
      # @param path [String] image path (use asset_path in views if needed)
      # @param operation [Symbol, String] e.g. :cover, :width, :height
      # @param options [Hash] operation options (e.g. width:, height:, options: { blur: 2 })
      # @param source [String, nil] optional source name when using config.imageboss.sources
      # @return [String] ImageBoss URL, or fallback URL when disabled
      def imageboss_url(path, operation, options = {}, source: nil)
        resolved_path = respond_to?(:asset_path, true) ? asset_path(path) : path
        url = imageboss_client(source: source)
          .path(resolved_path)
          .operation(operation.to_sym, options)
        url = apply_asset_host(url, resolved_path) if url == resolved_path && asset_host_for_fallback
        url.is_a?(String) ? url.html_safe : url.to_s.html_safe
      end

      private

      def imageboss_client(source: nil)
        config = ::ImageBoss::Rails.config.imageboss || {}
        client_options = {}

        if config[:sources].present?
          source_name = source || config[:default_source] || config[:sources].keys.first
          client_options[:source] = source_name
          client_options[:secret] = config[:sources][source_name]
        else
          client_options[:source] = config[:source]
          client_options[:secret] = config[:secret] || false
        end

        client_options[:enabled] = config[:enabled] unless config[:enabled].nil?

        ::ImageBoss::Client.new(**client_options)
      end

      def asset_host_for_fallback
        ::ImageBoss::Rails.config.imageboss && ::ImageBoss::Rails.config.imageboss[:asset_host]
      end

      def apply_asset_host(returned_path, resolved_path)
        host = asset_host_for_fallback
        return returned_path unless host
        base = host.to_s.sub(/\/*\z/, '')
        path = resolved_path.to_s.sub(/\A\/*/, '/')
        "#{base}#{path}"
      end
    end
  end
end

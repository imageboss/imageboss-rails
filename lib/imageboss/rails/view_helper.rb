module ImageBoss
  module Rails
    module ViewHelper
      include ActionView::Helpers
      include ImageBoss::Rails::UrlHelper

      # Options: +:tag_options+ (Hash merged into the <img> tag),
      # +:srcset_options+ (Hash with +:widths+ array or +:min_width+/+:max_width+ for responsive srcset),
      # +:attribute_options+ (Hash e.g. +{ src: 'data-src', srcset: 'data-srcset' }+ for lazy loading).
      # Any other keyword args are passed to the <img> tag. The 4th positional arg is merged into tag options (backward compatible).
      #
      # @param path [String] image path (passed through asset_path)
      # @param operation [Symbol, String] e.g. :cover, :width, :height
      # @param options [Hash] operation options
      # @param image_opts [Hash] legacy 4th arg; merged into tag options
      # @param tag_options [Hash] merged into the generated tag (e.g. class:, alt:)
      # @param srcset_options [Hash, nil] +widths:+ [Array<Integer>] or +min_width:+ and +max_width:+ for srcset
      # @param attribute_options [Hash] rename src/srcset (e.g. for lazy loading). Use tag_options[:src] as placeholder when lazy.
      # @param source [String, nil] optional source when using multi-source config
      # Ruby 2.7: trailing hash can become keyword args; **extra absorbs them so options stay a hash.
      def imageboss_tag(path, operation, options = {}, image_opts = {}, tag_options: {}, srcset_options: nil, attribute_options: nil, source: nil, **image_tag_opts)
        tag_options = image_opts.merge(tag_options)
        # Absorb operation options passed as keyword args (Ruby 2.7)
        operation_keys = %i[width height options]
        extra_opts = image_tag_opts.select { |k, _| operation_keys.include?(k) }
        options = options.merge(extra_opts) if extra_opts.any?
        image_tag_opts = image_tag_opts.reject { |k, _| operation_keys.include?(k) } if extra_opts.any?
        resolved_path = asset_path(path)
        widths = srcset_options[:widths] || widths_from_range(srcset_options) if srcset_options.present?
        if widths.present?
          main_options = options_for_main_url(operation, options, widths)
          url = imageboss_url(resolved_path, operation.to_sym, main_options, source: source)
          srcset = build_srcset(resolved_path, operation, options, widths, source: source)
          attrs = build_img_attrs(url, srcset, tag_options: tag_options, attribute_options: attribute_options, **image_tag_opts)
          content_tag(:img, nil, attrs)
        else
          url = imageboss_url(resolved_path, operation.to_sym, options, source: source)
          attrs = { src: url }
          attrs = apply_attribute_options(attrs, attribute_options)
          attrs[:src] = tag_options[:src] if attribute_options.present? && tag_options.key?(:src)
          attrs = tag_options.merge(image_tag_opts).merge(attrs)
          content_tag(:img, nil, attrs)
        end
      end

      # Generate a <picture> with optional breakpoints (media queries) and different URL params per breakpoint.
      #
      # @param path [String] image path
      # @param operation [Symbol, String] default operation
      # @param options [Hash] default operation options
      # @param breakpoints [Hash] media query => Hash with +:url_params+ (and optional +:srcset_options+)
      # @param tag_options [Hash] attributes for the <picture> element
      # @param img_tag_options [Hash] attributes for the fallback <img>
      # @param source [String, nil] optional source when using multi-source config
      # Ruby 2.7: trailing hash can become keyword args; absorb operation keys into options.
      def imageboss_picture_tag(path, operation, options = {}, breakpoints: {}, tag_options: {}, img_tag_options: {}, source: nil, **default_tag_opts)
        operation_keys = %i[width height options]
        extra_opts = default_tag_opts.select { |k, _| operation_keys.include?(k) }
        options = options.merge(extra_opts) if extra_opts.any?
        default_tag_opts = default_tag_opts.reject { |k, _| operation_keys.include?(k) } if extra_opts.any?

        resolved_path = asset_path(path)
        fallback_url = imageboss_url(resolved_path, operation.to_sym, options, source: source)

        sources = breakpoints.map do |media, opts|
          url_params = opts[:url_params] || options
          op = (opts[:operation] || operation).to_sym
          srcset_opts = opts[:srcset_options]
          url = imageboss_url(resolved_path, op, url_params, source: source)
          srcset = if srcset_opts && (widths = srcset_opts[:widths] || widths_from_range(srcset_opts))
            build_srcset(resolved_path, op, url_params, widths, source: source)
          end
          content_tag(:source, nil, { srcset: srcset || url, media: media }.compact)
        end

        img_attrs = img_tag_options.merge(src: fallback_url, alt: img_tag_options[:alt])
        content_tag(:picture, tag_options.merge(default_tag_opts)) do
          (sources << content_tag(:img, nil, img_attrs)).join.html_safe
        end
      end

      private

      def options_for_main_url(operation, options, widths)
        opts = options.dup
        first_w = widths.first
        case operation.to_sym
        when :width
          opts[:width] = opts[:width] || first_w
        when :height
          opts[:height] = opts[:height] || first_w
        when :cover
          if !opts.key?(:width) && !opts.key?(:height)
            opts[:width] = opts[:height] = first_w
          elsif opts[:width] && !opts.key?(:height)
            opts[:height] = opts[:width]
          elsif opts[:height] && !opts.key?(:width)
            opts[:width] = opts[:height]
          end
        end
        opts
      end

      def widths_from_range(srcset_options)
        min = srcset_options[:min_width]
        max = srcset_options[:max_width]
        return nil unless min && max && min <= max
        step = srcset_options[:width_step] || 160
        (min..max).step(step).to_a
      end

      def build_srcset(resolved_path, operation, options, widths, source: nil)
        widths.map do |w|
          opts = options.dup
          if operation == :cover && options[:width] && options[:height]
            ratio = options[:height].to_f / options[:width]
            opts = opts.merge(width: w, height: (w * ratio).round)
          elsif operation == :height
            opts = opts.merge(height: w)
          else
            opts = opts.merge(width: w)
          end
          url = imageboss_url(resolved_path, operation, opts, source: source)
          "#{url} #{w}w"
        end.join(", ")
      end

      def build_img_attrs(main_url, srcset, tag_options: {}, attribute_options: nil, **image_tag_opts)
        sizes = image_tag_opts.delete(:sizes) || tag_options.delete(:sizes) || "100vw"
        base = { src: main_url, srcset: srcset, sizes: sizes }
        base = apply_attribute_options(base, attribute_options)
        base[:src] = tag_options[:src] if attribute_options.present? && tag_options.key?(:src)
        tag_options.merge(image_tag_opts).merge(base)
      end

      def apply_attribute_options(attrs, attribute_options)
        return attrs if attribute_options.blank?
        result = attrs.stringify_keys
        attribute_options.each do |from, to|
          key = from.to_s
          next unless result.key?(key)
          result[to.to_s] = result.delete(key)
        end
        result
      end
    end
  end
end

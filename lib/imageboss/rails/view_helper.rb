module ImageBoss
  module Rails
    module ViewHelper
      include ActionView::Helpers
      include ImageBoss::Rails::UrlHelper

      def imageboss_tag(path, operation, options, image_opts = {})
        image_url = imageboss_url(asset_path(path), operation.to_sym, options)
        image_tag(image_url, image_opts)
      end
    end
  end
end

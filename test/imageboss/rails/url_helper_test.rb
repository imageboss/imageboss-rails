require 'test_helper'
require 'action_view'
require 'imageboss/rails/view_helper'

class ImageBoss::Rails::UrlHelper::Test < ActiveSupport::TestCase

  helper = ->() {
    Class.new do
      include ImageBoss::Rails::ViewHelper
      include ActionView::Context
    end.new
  }

  source = ->() { 'https://mywebsite.com' }

  ImageBoss::Rails.configure do |config|
    config.imageboss = {
      asset_host: source.call,
      enabled: true
    }
  end

  test '#url_helper' do
    url = helper.call.imageboss_url(
      '/assets/nice.jpg', :cover, { width: 100, height: 100 }
    )

    assert_equal('https://service.imageboss.me/cover/100x100/https://mywebsite.com/assets/nice.jpg', url)
  end
end

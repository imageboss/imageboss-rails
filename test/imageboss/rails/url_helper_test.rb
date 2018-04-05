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

  test '#url_helper' do
    app = ->() { Class.new(::Rails::Application) }
    source = ->() { 'https://mywebsite.com' }

    ImageBoss::Rails.configure do |config|
      config.imageboss = { assets_host: source.call }
    end

    url = helper.call.imageboss_url(
      '/assets/nice.jpg', [:cover, { width: 100, height: 100 }]
    )

    assert_equal(url, 'https://service.imageboss.me/cover/100x100/https://mywebsite.com/assets/nice.jpg')
  end
end

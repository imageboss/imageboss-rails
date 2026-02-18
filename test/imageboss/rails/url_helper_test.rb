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

  source = ->() { 'mywebsite' }

  setup do
    ImageBoss::Rails.configure do |config|
      config.imageboss = {
        source: source.call,
        enabled: true
      }
    end
  end

  test '#url_helper' do
    url = helper.call.imageboss_url(
      '/assets/nice.jpg', :cover, **{ width: 100, height: 100 }
    )

    assert_equal('https://img.imageboss.me/mywebsite/cover/100x100/assets/nice.jpg', url)
  end
end

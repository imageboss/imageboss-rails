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

  test '#url_helper_secure' do
    ImageBoss::Rails.configure do |config|
      config.imageboss = { source: source.call, secret: 'abc' }
    end

    url = helper.call.imageboss_url(
      '/assets/nice.jpg', :cover, **{ width: 100, height: 100 }
    )

    assert_equal('https://img.imageboss.me/mywebsite/cover/100x100/assets/nice.jpg?bossToken=d57ed7d86ca51e01afb0b7cc28d548bde6ed394f4a0c0618d2dc9cec21dd7c92', url)
  end
end

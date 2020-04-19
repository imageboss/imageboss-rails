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
      '/assets/nice.jpg', :cover, { width: 100, height: 100 }
    )

    assert_equal('https://img.imageboss.me/mywebsite/cover/100x100/assets/nice.jpg?bossToken=45ca1d7fc3adb066fb8114ef87e8a9ee03ef35fde138e4e579d2a6fd45fe887d', url)
  end
end

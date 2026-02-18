require 'test_helper'
require 'action_view'
require 'imageboss/rails/view_helper'

class ImageBoss::Rails::AssetHostTest < ActiveSupport::TestCase
  helper = ->() {
    Class.new do
      include ImageBoss::Rails::ViewHelper
      include ActionView::Context
    end.new
  }

  test 'when enabled is false and asset_host is set, url uses asset_host' do
    ImageBoss::Rails.configure do |config|
      config.imageboss = {
        source: 'mywebsite',
        enabled: false,
        asset_host: 'https://mycdn.com'
      }
    end

    url = helper.call.imageboss_url('/assets/nice.jpg', :cover, **{ width: 100, height: 100 })
    assert_equal('https://mycdn.com/assets/nice.jpg', url)
  end

  test 'when enabled is false and asset_host not set, url returns path from client' do
    ImageBoss::Rails.configure do |config|
      config.imageboss = { source: 'mywebsite', enabled: false }
    end

    url = helper.call.imageboss_url('/assets/nice.jpg', :cover, **{ width: 100, height: 100 })
    # Client returns path as-is when disabled
    assert_equal('/assets/nice.jpg', url)
  end
end

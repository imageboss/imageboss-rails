require 'test_helper'
require 'imageboss/rails/view_helper'

class ImageBoss::Rails::ViewHelper::Test < ActiveSupport::TestCase

  helper = ->() {
    Class.new do
      include ImageBoss::Rails::ViewHelper
      include ActionView::Context
    end.new
  }

  test 'view_helper#imageboss_tag' do
    source = ->() { 'mywebsite' }

    ImageBoss::Rails.configure do |config|
      config.imageboss = { source: source.call }
    end

    image_tag = helper.call.imageboss_tag('/assets/nice.jpg', :cover, **{ width: 100, height: 100 })
    assert_match('https://img.imageboss.me/mywebsite/cover/100x100/assets/nice.jpg', image_tag)

    image_tag = helper.call.imageboss_tag('/assets/nice.jpg', :cover, **{ width: 100, height: 100, options: { blur: 2 } })
    assert_match('https://img.imageboss.me/mywebsite/cover/100x100/blur:2/assets/nice.jpg', image_tag)
  end
end

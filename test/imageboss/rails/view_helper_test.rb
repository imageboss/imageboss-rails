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
    app = ->() { Class.new(::Rails::Application) }
    source = ->() { 'https://mywebsite.com' }

    ImageBoss::Rails.configure do |config|
      config.imageboss = { assets_host: source.call }
    end

    image_tag = helper.call.imageboss_tag('/assets/nice.jpg', :cover, { width: 100, height: 100 })

    assert_equal(image_tag, '<img src="https://service.imageboss.me/cover/100x100/https://mywebsite.com/assets/nice.jpg" alt="Nice" />')
  end
end

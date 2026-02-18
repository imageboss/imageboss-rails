require 'test_helper'
require 'action_view'
require 'imageboss/rails/view_helper'

class ImageBoss::Rails::MultiSourceTest < ActiveSupport::TestCase
  helper = ->() {
    Class.new do
      include ImageBoss::Rails::ViewHelper
      include ActionView::Context
    end.new
  }

  setup do
    ImageBoss::Rails.configure do |config|
      config.imageboss = {
        sources: {
          'source-a' => nil,
          'source-b' => 'secret123'
        },
        default_source: 'source-a',
        enabled: true
      }
    end
  end

  test 'imageboss_url uses default_source when source not given' do
    url = helper.call.imageboss_url('/assets/nice.jpg', :cover, **{ width: 100, height: 100 })
    assert_match(/img\.imageboss\.me\/source-a\//, url)
  end

  test 'imageboss_url uses given source when source: passed' do
    url = helper.call.imageboss_url('/assets/nice.jpg', :cover, **{ width: 100, height: 100 }, source: 'source-b')
    assert_match(/img\.imageboss\.me\/source-b\//, url)
  end

  test 'imageboss_tag accepts source:' do
    tag = helper.call.imageboss_tag('/assets/nice.jpg', :cover, **{ width: 100, height: 100 }, source: 'source-b')
    assert_match(/img\.imageboss\.me\/source-b\//, tag)
  end
end

require 'test_helper'
require 'imageboss/rails/view_helper'

class ImageBoss::Rails::SrcsetAndPictureTest < ActiveSupport::TestCase
  helper = ->() {
    Class.new do
      include ImageBoss::Rails::ViewHelper
      include ActionView::Context
    end.new
  }

  setup do
    ImageBoss::Rails.configure do |config|
      config.imageboss = { source: 'mywebsite', enabled: true }
    end
  end

  test 'imageboss_tag with srcset_options widths' do
    tag = helper.call.imageboss_tag(
      '/assets/nice.jpg', :width, { width: 800 },
      srcset_options: { widths: [320, 640, 960] },
      sizes: '100vw',
      alt: 'Responsive'
    )
    assert_match(/src="https:\/\/img\.imageboss\.me\/mywebsite\/width\/800/, tag)
    assert_match(/srcset=/, tag)
    assert_match(/320w/, tag)
    assert_match(/640w/, tag)
    assert_match(/960w/, tag)
    assert_match(/sizes="100vw"/, tag)
  end

  test 'imageboss_tag with srcset_options min_width max_width' do
    tag = helper.call.imageboss_tag(
      '/assets/nice.jpg', :width, {},
      srcset_options: { min_width: 320, max_width: 640, width_step: 160 },
      alt: 'Range'
    )
    assert_match(/srcset=/, tag)
    assert_match(/320w/, tag)
    assert_match(/480w/, tag)
    assert_match(/640w/, tag)
  end

  test 'imageboss_picture_tag with breakpoints' do
    tag = helper.call.imageboss_picture_tag(
      '/assets/hero.jpg', :cover, { width: 800, height: 600 },
      breakpoints: {
        '(max-width: 640px)' => { url_params: { width: 400, height: 300 } },
        '(min-width: 641px)' => { url_params: { width: 800, height: 600 } }
      },
      img_tag_options: { alt: 'Hero' }
    )
    assert_match(/<picture/, tag)
    assert_match(/<source[^>]+media="\(max-width: 640px\)"/, tag)
    assert_match(/<source[^>]+media="\(min-width: 641px\)"/, tag)
    assert_match(/cover\/400x300/, tag)
    assert_match(/cover\/800x600/, tag)
    assert_match(/<img[^>]+alt="Hero"/, tag)
  end

  test 'imageboss_tag with attribute_options for lazy loading' do
    tag = helper.call.imageboss_tag(
      '/assets/nice.jpg', :cover, { width: 100, height: 100 },
      attribute_options: { src: 'data-src' },
      tag_options: { src: 'placeholder.jpg' },
      alt: 'Lazy'
    )
    assert_match(/data-src="https:\/\/img\.imageboss\.me/, tag)
    assert_match(/src="placeholder\.jpg"/, tag)
    assert_match(/alt="Lazy"/, tag)
  end
end

require 'test_helper'

class ImageBoss::Rails::Test < ActiveSupport::TestCase
  setup do
    ImageBoss::Rails.configure { |config| config.imageboss = {} }
  end

  test 'everything is there' do
    assert_kind_of Module, ImageBoss::Rails
    assert_kind_of Class, ImageBoss::Client
    assert_not(ImageBoss::Rails::VERSION.nil?)
  end
end

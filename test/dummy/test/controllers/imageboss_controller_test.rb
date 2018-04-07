require 'test_helper'

class ImagebossControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get imageboss_index_url
    assert_response :success
  end

end

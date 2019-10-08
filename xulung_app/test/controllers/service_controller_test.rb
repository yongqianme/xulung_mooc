require 'test_helper'

class ServiceControllerTest < ActionController::TestCase
  test "should get telephone" do
    get :telephone
    assert_response :success
  end

  test "should get consultant" do
    get :consultant
    assert_response :success
  end

end

require 'test_helper'

class WelcomeHelperTest < ActionView::TestCase
	test "should get index" do
		get :index
		assert_response :success
	end
	test "should get home" do
		get :home
		assert_response :success
	end
end

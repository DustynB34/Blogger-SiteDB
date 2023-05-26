require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test 'should get all blogs' do
    get '/blog', headers: @Auth_user1, as: :json
    assert_response :success
  end
end

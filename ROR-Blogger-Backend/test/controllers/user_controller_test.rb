require "test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest

  test "should create" do
    post user_index_url, params: { username: 'testuser', email: 'testuser@test.com', password: "password1", first_name: 'test',  last_name: 'user', dob: 1 }, as: :json
    assert_response :success
  end

  test "should not create if email taken" do
    post user_index_url, params: { username: 'testuser', email: users(:one).email, password: "password1", first_name: users(:one).first_name,  last_name: users(:one).last_name, dob: users(:one).dob }, as: :json
    assert_response :unprocessable_entity
  end

end

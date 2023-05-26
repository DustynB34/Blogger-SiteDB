require 'test_helper'
require_relative '../../app/controllers/concerns/json_web_token'

class SessionControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:johnd)
  end

  test 'should login' do
    post '/login', params: { email: @user1.email, password: 'password1' }, as: :json
    assert_response :created
    assert JSON.parse(response.body)['first_name'] == @user1.first_name
    assert JSON.parse(response.body)['last_name'] == @user1.last_name
    assert JsonWebToken.decode(JSON.parse(response.body)['token'])['user_id'] == @user1.id
    # get '/blog', headers: { 'Authorization' => JSON.parse(response.body)['token'] }, as: :json
    # assert_response :ok
  end

  test 'should not login if username is bad' do
    post '/login', params: { email: 'nope, not a valid email', password: 'password1' }, as: :json
    assert_response :unauthorized
  end

  test 'should not login when password is bad' do
    post '/login', params: { email: @user1.email, password: 'bad password >:3' }, as: :json
    assert_response :unauthorized
  end

  test 'should not login when json is missing' do
    post '/login'
    assert_response :unauthorized
  end

  test 'authorization fails when token is missing' do
    get user_blog_index_url(@user1)
    assert_response :unauthorized
  end

  test 'authorization fails when token is expired' do
    token = JWT.encode({ user_id: @user1.id, exp: 1.seconds.from_now.to_i }, Rails.application.secret_key_base, 'HS256')
    sleep(2)
    get user_blog_index_url(@user1), headers: { 'Authorization' => token }, as: :json
    assert_response :unauthorized
  end
end

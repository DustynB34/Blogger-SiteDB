require 'test_helper'
require_relative '../../app/controllers/concerns/json_web_token'

class BlogControllerTest < ActionDispatch::IntegrationTest


  def setup
    @user1 = users(:johnd)
    @user1_token = JsonWebToken.encode('user_id': @user1.id)
    @Auth_user1 = {'Authorization' => "Bearer #{@user1_token}"}
    @blog1 = blogs(:blog1)
    @blog2 = blogs(:blog2)
    @topic1 = topics(:topic1).id
  end

  test 'should get index' do
    get user_blog_index_url(@user1), headers: @Auth_user1, as: :json
    assert_response :success
  end

  test 'should get index but empty because id doesnt exist' do
    get "/user/0/blog", headers: @Auth_user1, as: :json
    assert_response :ok
    assert JSON.parse(response.body) == []
  end

  test 'should get show' do
    get user_blog_url(@user1, @blog1), headers: @Auth_user1, as: :json
    assert_response :success
  end

  test 'should not show if user does not exist' do
    get user_blog_url(123, @blog1), headers: @Auth_user1, as: :json
    assert_response :unprocessable_entity
  end

  test 'should not show if blog does not exist' do
    get user_blog_url(@user1, 123), headers: @Auth_user1, as: :json
    assert_response :unprocessable_entity
  end

  test 'should create' do
    assert_difference 'Blog.count', 1 do
      post user_blog_index_url(@user1), params: { title: 'Test blog', content: 'Test blog content...',
                                           age_rating: 0, topic_id: @topic1 },
           headers: @Auth_user1, as: :json
      assert_response :created
    end
  end

  test 'should not create with invalid input' do
    assert_no_difference 'Blog.count' do
      post user_blog_index_url(@user1), params: { title: '', content: 'Test blog content...' },
           headers: @Auth_user1, as: :json
      assert_response :unprocessable_entity
    end
  end

  test 'should not create if token invalid' do
    assert_no_difference 'Blog.count' do
      post user_blog_index_url(@user1), params: { title: 'Test blog', content: 'Test blog content...' },
           headers: { Authorization: "Bearer #{}" }, as: :json
      assert_response :unauthorized
    end
  end

  test 'should update' do
    put user_blog_url(@user1.id, @blog1.id), headers: @Auth_user1, params: { title: 'change title', content: 'Auth_user1 content 123' } ,as: :json
    blog = Blog.find(@blog1.id)
    assert_equal blog.title, 'change title'
    assert_equal blog.content, 'Auth_user1 content 123'
    assert_response :success
  end

  test 'should not update with invalid input' do
    put user_blog_url(@user1.id, @blog1.id), headers: @Auth_user1, params: { title: "" },as: :json
    assert_response :unprocessable_entity
  end

  test 'should update viewcount' do
    put user_blog_viewcount_url(@user1.id, @blog1.id), headers: @Auth_user1, as: :json
    @blog = Blog.where(id: @blog1.id).first
    assert_equal @blog.views, 4
    assert_response :success
  end

  test 'should not update view count if blog not found' do
    put user_blog_viewcount_url(@user1.id, 123), headers: @Auth_user1, as: :json
    assert_response :unprocessable_entity
  end

  test 'should not update view count with param' do
    put user_blog_url(@user1.id, @blog1.id), headers: @Auth_user1, params: { views: '5' }, as: :json
    blog = Blog.find(@blog1.id)
    assert_not_equal blog.views, 5
    assert_response :success
  end

  test 'should not update if blog not found' do
    put user_blog_url(@user1.id, 123), headers: @Auth_user1, as: :json
    assert_response :unprocessable_entity
  end

  test 'should destroy' do
    assert_difference 'Blog.count', -1 do
      delete user_blog_url(@user1.id, @blog1.id), headers: @Auth_user1, as: :json
      assert_response :ok
    end
  end

  test 'should not destroy if unowned' do
    assert_no_difference 'Blog.count' do
      delete user_blog_url(@user1.id, @blog2.id), headers: @Auth_user1, as: :json
      assert_response :forbidden
    end
  end

  test 'should not destroy if blog not found' do
    assert_no_difference 'Blog.count' do
      delete user_blog_url(@user1.id, 123), headers: @Auth_user1, as: :json
      assert_response :unprocessable_entity
    end
  end


end

class BlogController < ApplicationController
  include Authenticate

  def initialize
    super
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
  end

  def index
    Rails.logger.info('Blog Index action: Called')
    blogs = Blog.includes(:user).where(user_id: params[:user_id])
    render json: blogs.as_json({ include: { user: { only: [:first_name, :last_name] } } }), status: :ok
  end

  def show
    Rails.logger.info("Blog Show action: Called on record #{params[:id]}")
    return render json: { message: 'User does not exist' },
                  status: :unprocessable_entity unless find_user(params[:user_id])

    Rails.logger.debug("Blog Show action: User: #{@user.id}")
    if find_blog(params[:id])
      Rails.logger.debug("Blog Show action: Blog: #{@blog.id}")
      render json: @blog.as_json({ include: { user: { only: [:first_name, :last_name] } } }), status: :ok
    else
      render json: { message: 'Blog does not exist' }, status: :unprocessable_entity
    end
  end

  def create
    Rails.logger.info('Blog Create action: Called')
    input = JSON.parse(request.body.read) # Reads the body of the post request
    Rails.logger.debug("Blog Create action: Data read: #{input.inspect}")
    input[:user_id] = @current_user.id # Obtains user id from token, forces proper ownership
    input[:views] = 0
    input[:likes] = 0
    input[:dislikes] = 0
    @blog = Blog.new(input)

    if @blog.save
      render json: { message: 'Blog created' }, status: :created
      Rails.logger.info('Blog Create action: Data successfully added to table') # If the data is saved to the database
    else # If user input is somehow wrong (eg. empty fields)
      render json: { message: 'Invalid blog creation' }, status: :unprocessable_entity
      Rails.logger.error('Create action: Input was invalid')
    end
  end

  def update_views
    Rails.logger.info("Blog Views action: Called on record #{params['blog_id']}")

    if find_blog(params['blog_id'])
      Rails.logger.info('Blog Views action: Blog found')
      # Update the record if possible
      @blog.update(views: @blog.views + 1)
      Rails.logger.info("Blog Views action: Successfully updated view count at ID: #{params['blog_id']}")
      render json: { message: 'Blog updated successfully' }, status: :ok
    else
      Rails.logger.info('Blog Views action: Cannot find blog')
      render json: { message: 'Cannot find blog' }, status: :unprocessable_entity
    end
  end

  def update
    Rails.logger.info("Blog Update action: Called on record #{params[:id]}")
    if find_blog(params[:id])
      Rails.logger.info('Blog Update action: Blog found')
      # check ownership
      return render json: { message: 'You do not own this blog' }, status: :forbidden unless owns?

      # Update the record if possible
      if @blog.update(blog_params)
        Rails.logger.info("Blog Update action: Successfully updated record: #{params[:id]}")
        render json: { message: 'Blog updated successfully' }, status: :ok
      else
        Rails.logger.info("Blog Update action: Failed to update record: #{params[:id]}")
        render json: { message: 'Invalid input' }, status: :unprocessable_entity
      end

    else
      render json: { message: 'Blog does not exist' }, status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.info("Blog Delete Action: Called on record #{params[:id]}")
    if find_blog(params[:id])
      return render json: { message: 'You are not authorized to delete this blog' }, status: :forbidden unless owns?

      Rails.logger.info('Blog Delete Action: Authorized')
      @blog.destroy
      render json: { message: 'Blog does not exist' }, status: :ok
      Rails.logger.info('Blog Delete Action: Blog deleted from database')
    else
      render json: { message: 'Blog does not exist' }, status: :unprocessable_entity
    end
  end

  private

  def owns?
    # Rails.logger.info("IDs: #{@blog.user_id}, #{@current_user.id}")
    # Rails.logger.info("Data types: #{ @blog.user_id.class }, #{ @current_user.id.class }")
    if @blog.user_id == @current_user.id
      Rails.logger.info('Blog Ownership check: User owns chosen blog')
      true
    else
      Rails.logger.info('Blog Ownership check: User does not own chosen blog')
      false
    end
  end

  def find_blog(id) # Use with a conditional statement
    @blog = Blog.find(id) # Finds blog in the database using active record
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error(e.message) # ActiveRecord returns an error if the blog is not found
    false
  end

  def find_user(id) # Use with a conditional statement
    @user = User.find(id) # Finds user in the database using active record
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error(e.message)
    false
  end

  def blog_params
    params.require(:blog).permit(:content, :title, :age_rating)
  end

end

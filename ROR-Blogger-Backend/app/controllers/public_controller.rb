class PublicController < ApplicationController

  def blog_index
    @blogs = Blog.includes(:user)
    return render json: @blogs.as_json(include: { user: { only: %i[first_name last_name] } })
  end

end

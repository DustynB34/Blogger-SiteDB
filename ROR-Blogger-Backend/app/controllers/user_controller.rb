class UserController < ApplicationController
  def index
  end

  def show
  end

  def create

    input = JSON.parse(request.body.read)
    input[:role] = 'publisher'
    @user = User.new(input)
    if @user.save
      render json: { user: @user }, status: :created
      Rails.logger.info('Users: User signed up')
    else
      render json: @user.errors, status: :unprocessable_entity
      # If saving user to database fails, possibly due to bad user input
      Rails.logger.warn('Users: Invalid user creation')
    end

  end

  def update
  end

  def destroy
  end
end
